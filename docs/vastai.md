## Setup
1. Create pytorch instance from the templates page: [link](https://cloud.vast.ai/templates/).
2. Connect from vscode through SSH.
3. Check torch is installed in `main` conda env: `pip freeze`
3. Install gsplat:
```bash
git clone 
cd gsplat
apt-get install libglm-dev
pip install -e . --no-build-isolation
cd examples
pip install -r requirements.txt --no-build-isolation
```