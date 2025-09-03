# AdSweep: Automated Swydo Reporting Aggregator

**AdSweep** is a Python-based automation tool designed to log into Swydo, navigate through various ad accounts, and aggregate key reporting data into a single, clean, and easy-to-read HTML document. It's built for agencies and individuals who manage numerous scattered accounts and need a consolidated daily overview without manual effort.

This tool uses the powerful **Playwright** library for robust, headless browser automation, ensuring it can handle modern, JavaScript-heavy web applications like Swydo reliably.

## Key Features

-   **Automated Login:** Securely logs into your Swydo account.
-   **Data Aggregation:** Scrapes data from specified accounts and reports.
-   **Modular Scrapers:** Easily add new scraping tasks for different sections of Swydo.
-   **Secure Credential Management:** Uses a `.env` file to keep your username and password out of the source code.
-   **Robust Error Handling:** Captures errors during scraping and provides screenshots for easy debugging.
-   **Clean HTML Reports:** Generates a single, scrollable HTML file with a timestamped summary of all accounts.

---

## Project Structure

AdSweep is organized for clarity and maintainability:

```
adsweep/
├── main.py                 # The main script to run the sweep.
├── requirements.txt        # Python dependencies.
├── .env.example            # Example credentials file.
├── .gitignore              # Ignores sensitive and temporary files.
├── sources/                # A module for each distinct scraping task.
│   ├── __init__.py
│   └── swydo_scraper.py      # The core logic for scraping Swydo.
├── report_generator.py     # Builds the final HTML report.
└── templates/              # Contains the HTML template for the report.
    └── report_template.html
└── output/                 # Where the final report and debug screenshots are saved.
    ├── ad_sweep_report.html
    └── screenshots/
```

---

## Getting Started

Follow these steps to get AdSweep running on your local machine.

### Prerequisites

-   Python 3.8 or newer
-   Access to a command line/terminal

### 1. Clone & Setup the Environment

First, clone the repository and set up a Python virtual environment.

```bash
# Clone the project (or create the directory structure)
git clone <your-repo-url> adsweep
cd adsweep

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 2. Install Dependencies

Install the required Python packages using `pip`.

```bash
# Install packages from requirements.txt
pip install -r requirements.txt

# Download the necessary browser binaries for Playwright
playwright install
```
*(File: `requirements.txt`)*
```
playwright
python-dotenv
jinja2
```

### 3. Configure Credentials

Your Swydo credentials must be stored securely.

1.  Make a copy of the example environment file:
    ```bash
    cp .env.example .env
    ```
2.  Open the newly created `.env` file and enter your Swydo login details.

*(File: `.env`)*
```ini
# --- AdSweep Configuration ---
# Enter your Swydo login credentials below

SWYDO_USERNAME="your-swydo-email@example.com"
SWYDO_PASSWORD="your-super-secret-password"
```
> **Security Note:** The `.gitignore` file is pre-configured to ignore the `.env` file, ensuring you never accidentally commit your credentials to a repository.

### 4. Customize the Scraper

The core logic resides in `sources/swydo_scraper.py`. You will need to customize this file to navigate to the specific reports you need.

**Tip:** Use Playwright's CodeGen tool to easily find the correct selectors. Run this command, and then manually perform the actions in the browser window that opens. Playwright will print the corresponding Python code for you.

```bash
playwright codegen https://app.swydo.com/
```

*(File: `sources/swydo_scraper.py`)*
```python
# sources/swydo_scraper.py

import os
import logging
from playwright.sync_api import Page, expect

# ... (logging configuration) ...

def get_swydo_data(page: Page) -> dict:
    """
    Logs into Swydo, scrapes ad account data, and returns it.
    """
    logging.info("Starting Swydo scraper...")
    username = os.getenv("SWYDO_USERNAME")
    password = os.getenv("SWYDO_PASSWORD")
    
    # ... (credential check) ...

    try:
        # 1. LOGIN
        logging.info("Navigating to Swydo login page.")
        page.goto("https://app.swydo.com/")
        page.get_by_label("Email").fill(username)
        page.get_by_label("Password").fill(password)
        page.get_by_role("button", name="Login").click()
        
        # Wait for dashboard to ensure login was successful
        expect(page.get_by_role("heading", name="Clients")).to_be_visible(timeout=20000)
        logging.info("Successfully logged into Swydo.")
        
        # 2. NAVIGATE & SCRAPE (!!! CUSTOMIZE THIS SECTION !!!)
        logging.info("Navigating to client reports...")
        # EXAMPLE: This is where you add your specific navigation and data extraction logic.
        # page.goto("https://app.swydo.com/reports/your-specific-report-url")
        #
        # account_rows = page.locator(".report-table tr").all()
        # for row in account_rows:
        #     # ... extract data from cells ...

        # Placeholder data - replace with your actual scraped data
        scraped_data = [
            {"Client": "Client Alpha", "Spend": "$1,200", "Conversions": "50"},
            {"Client": "Client Bravo", "Spend": "$3,500", "Conversions": "120"},
        ]

        logging.info(f"Successfully scraped data for {len(scraped_data)} clients.")
        
        return {"title": "Swydo Ad Accounts", "status": "success", "data": scraped_data}

    except Exception as e:
        # ... (error handling and screenshot logic) ...
        # ...
```

### 5. Run AdSweep

Execute the main script from your terminal. The tool will run in headless mode (no browser window will appear).

```bash
python main.py
```

-   The script will print its progress to the console.
-   Upon completion, a message will indicate where the report has been saved.
-   If any scraper fails, a screenshot will be saved in the `output/screenshots/` directory to help with debugging.

### 6. View the Report

Open the generated HTML file in your web browser to view the consolidated report.

`output/ad_sweep_report.html`

---

## How to Add a New Scraper

The project is designed to be easily extendable, for instance, if you wanted to scrape another platform in addition to Swydo.

1.  **Create a New Scraper File:** Add a new file like `new_platform_scraper.py` in the `sources/` directory.
2.  **Define a Scraper Function:** Inside the new file, create a function (e.g., `get_new_platform_data`) that follows the same pattern: it takes a `page` object and returns a dictionary.
3.  **Add Credentials:** Add the necessary credentials for the new platform to your `.env` file.
4.  **Register in `main.py`:** Import your new function in `main.py` and add it to the `scraper_jobs` list.

```python
# main.py

# ... imports ...
from sources.swydo_scraper import get_swydo_data
from sources.new_platform_scraper import get_new_platform_data # 1. Import

# ...
def main():
    # ...
    scraper_jobs = [
        get_swydo_data,
        get_new_platform_data, # 2. Add to list
    ]
    # ...
```