# Offline OCR Suite - Multi-Engine OCR System

A complete, extensible offline OCR system combining **Tesseract**, **EasyOCR**, and **PaddleOCR** for intelligent text extraction.

## Features

- 🔄 **Intelligent Auto-Selection** - Automatically picks best engine based on language and image type
- ⚡ **Smart Caching** - Results cached by image hash to avoid reprocessing
- 🖼️ **Advanced Preprocessing** - Deskewing, denoising, contrast enhancement
- 📊 **Engine Comparison** - Run all engines and compare outputs
- 🗳️ **Voting System** - Multiple engines "vote" on best text
- 📁 **Batch Processing** - Process folders with progress tracking
- 💾 **Multiple Interfaces** - CLI, GUI, and Python API
- 🔒 **100% Offline** - No internet required after setup

## Installation

### 1. Create Virtual Environment

```bash
cd offline_ocr_suite
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Install Tesseract (System Dependency)

**Windows:**
- Download from: https://github.com/UB-Mannheim/tesseract/wiki
- Install and add to PATH: `C:\Program Files\Tesseract-OCR`
- Or update `config.yaml` with the full path to `tesseract.exe`

**Ubuntu/Debian:**
```bash
sudo apt-get install tesseract-ocr tesseract-ocr-eng
```

**macOS:**
```bash
brew install tesseract tesseract-lang
```

## Usage

### Python API

```python
from ocr_manager import UnifiedOCR, OCREngine

# Initialize
ocr = UnifiedOCR()

# Single image - auto engine selection
results = ocr.recognize("document.png")
for r in results:
    print(f"[{r.engine}] {r.text} (confidence: {r.confidence:.2%})")

# Force specific engine
results = ocr.recognize("scan.jpg", engine=OCREngine.TESSERACT)

# Get best result only
best = ocr.recognize_best("photo.png", strategy="voting")
print(f"Best: {best.text} from {best.engine}")

# Batch processing
import glob
files = glob.glob("invoices/*.png")
ocr.batch_process(files, output_file="results.json")

# Compare engines
comparison = ocr.compare_engines("test.png")
for engine, results in comparison.items():
    print(f"{engine}: {len(results)} results")
```

### Command Line

```bash
# Basic OCR with auto engine
python ocr_cli.py document.png

# Use specific engine
python ocr_cli.py image.jpg -e tesseract -o output.json

# Compare all engines
python ocr_cli.py scan.png --compare

# Batch process directory
python ocr_cli.py ./invoices/ -e auto -o batch_results.json --best

# Chinese document
python ocr_cli.py chinese_doc.png -l ch -e paddleocr
```

### GUI Application

```bash
python ocr_gui.py
```

## Configuration

Edit `config.yaml` to customize:
- OCR engine settings (languages, models, GPU)
- Preprocessing options (deskew, denoise, DPI)
- Performance settings (caching, timeout)
- Logging configuration

## Engine Selection Logic

**AUTO mode** intelligently selects engines based on:
- **Asian languages** (Chinese, Japanese, Korean) → PaddleOCR → EasyOCR → Tesseract
- **High-res color images** (photos, screenshots) → EasyOCR → PaddleOCR → Tesseract
- **Scanned documents** → Tesseract → EasyOCR → PaddleOCR

## Project Structure

```
offline_ocr_suite/
├── ocr_manager.py      # Core OCR engine integration
├── ocr_cli.py          # Command-line interface
├── ocr_gui.py          # Tkinter GUI application
├── config.yaml         # Configuration file
├── requirements.txt    # Python dependencies
├── models/             # Downloaded OCR models (auto-created)
├── cache/              # Result cache (auto-created)
└── logs/               # Application logs (auto-created)
```

## Troubleshooting

**Tesseract not found:**
- Verify installation: `tesseract --version`
- Update `config.yaml` with full path to tesseract executable

**EasyOCR/PaddleOCR models downloading:**
- First run downloads models (~200MB each)
- Ensure stable internet connection on first use
- Models stored in `./models/` directory

**Import errors:**
- Ensure virtual environment is activated
- Reinstall: `pip install -r requirements.txt`

## GPU Support

To enable GPU acceleration (requires CUDA):

1. Uncomment GPU packages in `requirements.txt`
2. Set `gpu: true` in `config.yaml` for desired engines
3. Reinstall: `pip install -r requirements.txt`

## License

MIT License - Feel free to use and modify!
