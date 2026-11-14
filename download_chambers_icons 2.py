#!/usr/bin/env python3
"""
Download official chamber favicons/logos from the 50 official websites
already stored in Vacatory.

Run this file from:
    /Users/mariaosullivan/Documents/GitHub/vacatory-source

It creates:
    assets/chambers/<slug>.<extension>
    chambers-logo-updates.sql
    chambers-icon-report.csv
"""

from __future__ import annotations

import csv
import mimetypes
import re
import sys
import subprocess
import tempfile
from dataclasses import dataclass
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable
from urllib.parse import urljoin, urlparse


USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/605.1.15 (KHTML, like Gecko) Safari/605.1.15"
)
TIMEOUT_SECONDS = 18
MAX_IMAGE_BYTES = 5_000_000

CHAMBERS: list[tuple[str, str, str]] = [
    ("1 Crown Office Row", "1-crown-office-row", "https://www.1cor.com/"),
    ("1 Hare Court", "1-hare-court", "https://www.1hc.com/"),
    ("11KBW", "11kbw", "https://www.11kbw.com/"),
    ("12 Kings Bench Walk", "12-kings-bench-walk", "https://www.12kbw.co.uk/"),
    ("2 Hare Court", "2-hare-court", "https://www.2harecourt.com/"),
    ("3 Verulam Buildings", "3-verulam-buildings", "https://3vb.com/"),
    ("39 Essex Chambers", "39-essex-chambers", "https://www.39essex.com/"),
    ("3PB Barristers", "3pb-barristers", "https://www.3pb.co.uk/"),
    ("4 New Square Chambers", "4-new-square-chambers", "https://www.4newsquare.com/"),
    ("4 Pump Court", "4-pump-court", "https://www.4pumpcourt.com/"),
    ("4PB", "4pb", "https://www.4pb.com/"),
    ("5 Essex Chambers", "5-essex-chambers", "https://www.5essex.co.uk/"),
    ("5 Stone Buildings", "5-stone-buildings", "https://www.5sblaw.com/"),
    ("6KBW College Hill", "6kbw-college-hill", "https://6kbw.com/"),
    ("Atkin Chambers", "atkin-chambers", "https://www.atkinchambers.com/"),
    ("Blackstone Chambers", "blackstone-chambers", "https://www.blackstonechambers.com/"),
    ("Brick Court Chambers", "brick-court-chambers", "https://www.brickcourt.co.uk/"),
    ("Byrom Street Chambers", "byrom-street-chambers", "https://www.byromstreet.com/"),
    ("Civitas Chambers", "civitas-chambers", "https://www.civitaschambers.co.uk/"),
    ("Crown Office Chambers", "crown-office-chambers", "https://www.crownofficechambers.com/"),
    ("Doughty Street Chambers", "doughty-street-chambers", "https://www.doughtystreet.co.uk/"),
    ("Essex Court Chambers", "essex-court-chambers", "https://essexcourt.com/"),
    ("Exchange Chambers", "exchange-chambers", "https://www.exchangechambers.co.uk/"),
    ("Falcon Chambers", "falcon-chambers", "https://www.falcon-chambers.com/"),
    ("Fountain Court Chambers", "fountain-court-chambers", "https://www.fountaincourt.co.uk/"),
    ("Garden Court Chambers", "garden-court-chambers", "https://gardencourtchambers.co.uk/"),
    ("Garden Court North Chambers", "garden-court-north-chambers", "https://gcnchambers.co.uk/"),
    ("Guildhall Chambers", "guildhall-chambers", "https://www.guildhallchambers.co.uk/"),
    ("Henderson Chambers", "henderson-chambers", "https://www.hendersonchambers.co.uk/"),
    ("Keating Chambers", "keating-chambers", "https://www.keatingchambers.com/"),
    ("Kings Chambers", "kings-chambers", "https://www.kingschambers.com/"),
    ("Landmark Chambers", "landmark-chambers", "https://www.landmarkchambers.co.uk/"),
    ("Littleton Chambers", "littleton-chambers", "https://littletonchambers.com/"),
    ("Maitland Chambers", "maitland-chambers", "https://www.maitlandchambers.com/"),
    ("Matrix Chambers", "matrix-chambers", "https://www.matrixlaw.co.uk/"),
    ("Monckton Chambers", "monckton-chambers", "https://www.monckton.com/"),
    ("No5 Barristers' Chambers", "no5-barristers-chambers", "https://www.no5.com/"),
    ("Old Square Chambers", "old-square-chambers", "https://oldsquare.co.uk/"),
    ("One Essex Court", "one-essex-court", "https://www.oeclaw.co.uk/"),
    ("Outer Temple Chambers", "outer-temple-chambers", "https://www.outertemple.com/"),
    ("Parklane Plowden Chambers", "parklane-plowden", "https://www.parklaneplowden.co.uk/"),
    ("Pump Court Tax Chambers", "pump-court-tax-chambers", "https://www.pumptax.com/"),
    ("Serle Court", "serle-court", "https://www.serlecourt.co.uk/"),
    ("South Square", "south-square", "https://southsquare.com/"),
    ("St Ives Chambers", "st-ives-chambers", "https://stiveschambers.co.uk/"),
    ("St Philips Chambers", "st-philips-chambers", "https://st-philips.com/"),
    ("Three Raymond Buildings", "3-raymond-buildings", "https://3rblaw.com/"),
    ("Trinity Chambers", "trinity-chambers-north-east", "https://www.trinitychambers.co.uk/"),
    ("Twenty Essex", "twenty-essex", "https://www.twentyessex.com/"),
    ("Wilberforce Chambers", "wilberforce-chambers", "https://www.wilberforce.co.uk/"),
]


@dataclass
class IconCandidate:
    url: str
    rel: str
    sizes: str
    type_hint: str
    score: int


class IconParser(HTMLParser):
    def __init__(self, base_url: str) -> None:
        super().__init__()
        self.base_url = base_url
        self.candidates: list[IconCandidate] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag.lower() != "link":
            return

        data = {str(k).lower(): (v or "") for k, v in attrs}
        rel = data.get("rel", "").lower()
        href = data.get("href", "").strip()

        if not href or "icon" not in rel:
            return

        sizes = data.get("sizes", "").lower()
        type_hint = data.get("type", "").lower()
        score = score_icon(rel, sizes, type_hint, href)

        self.candidates.append(
            IconCandidate(
                url=urljoin(self.base_url, href),
                rel=rel,
                sizes=sizes,
                type_hint=type_hint,
                score=score,
            )
        )


def score_icon(rel: str, sizes: str, type_hint: str, href: str) -> int:
    score = 0

    if "apple-touch-icon" in rel:
        score += 500
    elif "icon" in rel:
        score += 300

    numbers = [int(n) for n in re.findall(r"\d+", sizes)]
    if numbers:
        score += min(max(numbers), 512)

    lower_href = href.lower()
    if lower_href.endswith(".svg") or "svg" in type_hint:
        score += 450
    elif lower_href.endswith(".png") or "png" in type_hint:
        score += 300
    elif lower_href.endswith(".webp") or "webp" in type_hint:
        score += 250
    elif lower_href.endswith(".ico") or "icon" in type_hint:
        score += 100

    if "mask-icon" in rel:
        score -= 100

    return score


def fetch(url: str) -> tuple[bytes, str, str]:
    """Fetch a URL with the Mac's built-in curl certificate store."""
    accept = (
        "text/html,application/xhtml+xml,image/avif,image/webp,"
        "image/apng,image/svg+xml,image/*,*/*;q=0.8"
    )

    with tempfile.TemporaryDirectory() as temp_dir:
        body_path = Path(temp_dir) / "body.bin"

        command = [
            "curl",
            "--location",
            "--fail",
            "--silent",
            "--show-error",
            "--connect-timeout",
            str(TIMEOUT_SECONDS),
            "--max-time",
            "35",
            "--user-agent",
            USER_AGENT,
            "--header",
            f"Accept: {accept}",
            "--output",
            str(body_path),
            "--write-out",
            "%{url_effective}\n%{content_type}",
            url,
        ]

        completed = subprocess.run(
            command,
            capture_output=True,
            text=True,
            check=False,
        )

        if completed.returncode != 0:
            message = completed.stderr.strip() or f"curl exited with code {completed.returncode}"
            raise OSError(message)

        output_lines = completed.stdout.splitlines()
        final_url = output_lines[0].strip() if output_lines else url
        content_type = output_lines[1].strip() if len(output_lines) > 1 else ""

        if not body_path.exists():
            raise OSError("No response file was created")

        if body_path.stat().st_size > MAX_IMAGE_BYTES:
            raise ValueError("File was larger than 5 MB")

        data = body_path.read_bytes()

    return data, content_type, final_url


def discover_candidates(homepage_url: str) -> list[IconCandidate]:
    data, content_type, final_url = fetch(homepage_url)

    if "html" not in content_type:
        raise ValueError(f"Homepage returned {content_type}, not HTML")

    html = data.decode("utf-8", errors="replace")
    parser = IconParser(final_url)
    parser.feed(html)

    common_paths = [
        ("/apple-touch-icon.png", 490),
        ("/apple-touch-icon-precomposed.png", 470),
        ("/favicon.svg", 460),
        ("/favicon-512x512.png", 440),
        ("/favicon-192x192.png", 420),
        ("/favicon-96x96.png", 400),
        ("/favicon-32x32.png", 380),
        ("/favicon.png", 350),
        ("/favicon.ico", 200),
    ]

    existing = {candidate.url for candidate in parser.candidates}
    for path, score in common_paths:
        candidate_url = urljoin(final_url, path)
        if candidate_url not in existing:
            parser.candidates.append(
                IconCandidate(
                    url=candidate_url,
                    rel="fallback",
                    sizes="",
                    type_hint="",
                    score=score,
                )
            )

    return sorted(parser.candidates, key=lambda item: item.score, reverse=True)


def extension_for(content_type: str, final_url: str, data: bytes) -> str:
    content_type = content_type.split(";", 1)[0].strip().lower()

    type_map = {
        "image/svg+xml": ".svg",
        "image/png": ".png",
        "image/webp": ".webp",
        "image/jpeg": ".jpg",
        "image/jpg": ".jpg",
        "image/gif": ".gif",
        "image/x-icon": ".ico",
        "image/vnd.microsoft.icon": ".ico",
        "application/octet-stream": "",
    }

    extension = type_map.get(content_type, "")
    if extension:
        return extension

    path_extension = Path(urlparse(final_url).path).suffix.lower()
    if path_extension in {".svg", ".png", ".webp", ".jpg", ".jpeg", ".gif", ".ico"}:
        return ".jpg" if path_extension == ".jpeg" else path_extension

    if data.startswith(b"\x89PNG\r\n\x1a\n"):
        return ".png"
    if data.startswith(b"\x00\x00\x01\x00"):
        return ".ico"
    if data.startswith((b"GIF87a", b"GIF89a")):
        return ".gif"
    if data.startswith(b"\xff\xd8\xff"):
        return ".jpg"
    if b"<svg" in data[:1000].lower():
        return ".svg"

    guessed = mimetypes.guess_extension(content_type)
    return guessed or ".img"


def looks_like_image(content_type: str, data: bytes, final_url: str) -> bool:
    if content_type.lower().startswith("image/"):
        return True

    ext = Path(urlparse(final_url).path).suffix.lower()
    if ext in {".svg", ".png", ".webp", ".jpg", ".jpeg", ".gif", ".ico"}:
        return True

    signatures = (
        b"\x89PNG\r\n\x1a\n",
        b"\x00\x00\x01\x00",
        b"GIF87a",
        b"GIF89a",
        b"\xff\xd8\xff",
    )
    return data.startswith(signatures) or b"<svg" in data[:1000].lower()


def remove_old_files(output_dir: Path, slug: str) -> None:
    for old_file in output_dir.glob(f"{slug}.*"):
        if old_file.is_file():
            old_file.unlink()


def sql_escape(value: str) -> str:
    return value.replace("'", "''")


def main() -> int:
    root = Path.cwd()
    expected_root_name = "vacatory-source"

    if root.name != expected_root_name:
        print(
            f"Please run this script inside the {expected_root_name} folder.\n"
            f"Current folder: {root}"
        )
        return 1

    output_dir = root / "assets" / "chambers"
    output_dir.mkdir(parents=True, exist_ok=True)

    results: list[dict[str, str]] = []

    print(f"Saving icons in: {output_dir}")
    print(f"Checking {len(CHAMBERS)} official websites...\n")

    for index, (name, slug, website_url) in enumerate(CHAMBERS, start=1):
        print(f"[{index:02d}/50] {name}")

        status = "failed"
        chosen_url = ""
        local_path = ""
        error_message = ""

        try:
            candidates = discover_candidates(website_url)
            errors: list[str] = []

            for candidate in candidates:
                try:
                    data, content_type, final_url = fetch(candidate.url)

                    if not looks_like_image(content_type, data, final_url):
                        errors.append(f"{candidate.url}: returned {content_type}")
                        continue

                    extension = extension_for(content_type, final_url, data)
                    if extension == ".img":
                        errors.append(f"{candidate.url}: unknown image format")
                        continue

                    remove_old_files(output_dir, slug)
                    filename = f"{slug}{extension}"
                    destination = output_dir / filename
                    destination.write_bytes(data)

                    status = "downloaded"
                    chosen_url = final_url
                    local_path = f"assets/chambers/{filename}"
                    print(f"  Saved {local_path}")
                    break

                except (TimeoutError, ValueError, OSError) as exc:
                    errors.append(f"{candidate.url}: {exc}")

            if status != "downloaded":
                error_message = " | ".join(errors[-3:]) or "No usable icon found"
                print("  No usable icon found")

        except (TimeoutError, ValueError, OSError) as exc:
            error_message = str(exc)
            print(f"  Could not open website: {exc}")

        results.append(
            {
                "name": name,
                "slug": slug,
                "website_url": website_url,
                "status": status,
                "official_icon_url": chosen_url,
                "local_path": local_path,
                "error": error_message,
            }
        )

    report_path = root / "chambers-icon-report.csv"
    with report_path.open("w", newline="", encoding="utf-8") as report_file:
        writer = csv.DictWriter(
            report_file,
            fieldnames=[
                "name",
                "slug",
                "website_url",
                "status",
                "official_icon_url",
                "local_path",
                "error",
            ],
        )
        writer.writeheader()
        writer.writerows(results)

    successful = [row for row in results if row["status"] == "downloaded"]
    failed = [row for row in results if row["status"] != "downloaded"]

    sql_path = root / "chambers-logo-updates.sql"
    with sql_path.open("w", encoding="utf-8") as sql_file:
        sql_file.write("begin;\n\n")
        sql_file.write("-- Official chamber icons saved locally in Vacatory.\n")
        sql_file.write("-- Safe to rerun.\n\n")

        for row in successful:
            logo_url = sql_escape(row["local_path"])
            slug = sql_escape(row["slug"])
            sql_file.write(
                "update public.legal_organisations\n"
                f"set logo_url = '{logo_url}', updated_at = now()\n"
                f"where slug = '{slug}'\n"
                "  and organisation_type = 'barristers_chambers';\n\n"
            )

        sql_file.write("commit;\n\n")
        sql_file.write(
            "select name, slug, logo_url\n"
            "from public.legal_organisations\n"
            "where organisation_type = 'barristers_chambers'\n"
            "  and active = true\n"
            "order by name;\n"
        )

    print("\nFinished.")
    print(f"Downloaded: {len(successful)}")
    print(f"Still needing manual attention: {len(failed)}")
    print(f"Report: {report_path.name}")
    print(f"SQL: {sql_path.name}")

    if failed:
        print("\nNot downloaded:")
        for row in failed:
            print(f"  - {row['name']}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
