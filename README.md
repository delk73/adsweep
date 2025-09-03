# AdSweep: Automated Swydo Reporting Aggregator

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

AdSweep is a Python-based web scraper designed to automate the process of logging into Swydo, navigating to specific reports, and generating a consolidated HTML output. It uses Playwright for browser automation.

## Features

*   Automated login to Swydo.
*   Scraping of specified Swydo reports.
*   Generation of a single, consolidated HTML report from the scraped data.
*   Screenshots of the reports for verification.
*   Headless browser operation for server-based execution.

## Prerequisites

Before you begin, ensure you have the following installed:
*   [Git](https://git-scm.com/)
*   [Python](https://www.python.org/downloads/) (version 3.8 or higher)
*   [Poetry](https://python-poetry.org/docs/#installation) for dependency management

## Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/adsweep.git
    cd adsweep
    ```

2.  **Bootstrap the project:**
    This command will install all the necessary Python dependencies using Poetry and download the required Playwright browser binaries.
    ```bash
    make bootstrap
    ```
    Alternatively, you can run the steps manually:
    ```bash
    poetry install
    poetry run playwright install
    ```

## Configuration

AdSweep requires credentials to log into Swydo. These are managed via a `.env` file.

1.  **Create a `.env` file** by copying the example file:
    ```bash
    cp .env.example .env
    ```

2.  **Edit the `.env` file** with your Swydo credentials and the report URLs you want to scrape:
    ```
    # .env
    SWYDO_EMAIL="your_email@example.com"
    SWYDO_PASSWORD="your_password"
    # Add the full URLs of the Swydo reports to scrape
    REPORT_URLS="https://app.swydo.com/reports/12345,https://app.swydo.com/reports/67890"
    ```

## Usage

To run the scraper, execute the following command:
```bash
make run
```
This will start the scraping process. The output, including the consolidated `report.html` and screenshots, will be saved in the `output/` directory.

## Development

The project uses a `Makefile` to streamline common development tasks.

*   `make help`: Show all available Make targets.
*   `make install`: Install Python dependencies.
*   `make playwright-install`: Install Playwright browser binaries.
*   `make bootstrap`: A one-stop command to set up the project.
*   `make run`: Run the AdSweep scraper.
*   `make shell`: Open an interactive shell within the project's virtual environment.
*   `make lint`: (Placeholder) Run linters and tests.
*   `make clean`: Remove temporary files and build artifacts.

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
