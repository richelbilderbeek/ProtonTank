"""Check that the game runs in a browser and that the keys work."""
import sys
import time

from playwright.sync_api import sync_playwright

URL = "http://localhost:8000/protontank.html"


def hold(page, keys, seconds=0.5):
    """Hold keys down together, as a tank only moves while keys are held."""
    for key in keys:
        page.keyboard.down(key)
    time.sleep(seconds)
    for key in keys:
        page.keyboard.up(key)


with sync_playwright() as p:
    browser = p.chromium.launch()
    # About the size of the iframe on the website
    page = browser.new_page(viewport={"width": 680, "height": 400})
    errors = []
    page.on("pageerror", lambda e: errors.append(str(e)))
    page.goto(URL)
    time.sleep(3)
    page.mouse.click(340, 200)
    before = page.screenshot()
    # Both wheels of the red tank forward: the red tank drives
    hold(page, ["q", "u"])
    # One wheel of the blue tank forward: the blue tank turns
    hold(page, ["r"])
    time.sleep(0.5)
    after_keys = page.screenshot()
    browser.close()

if errors:
    sys.exit(f"Page errors: {errors}")
if before == after_keys:
    sys.exit("Pressing keys did not change the page")
print("OK")
