#!/bin/bash

set -e

source dev-container-features-test-lib

check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "uv is available" uv --version
check "ruff is available" ruff --version
check "pytorch is importable" python3 -c "import torch; print(torch.__version__)"
check "cpu-only pytorch build" python3 -c "import torch; assert not torch.version.cuda, 'Expected CPU build'"
check "torchvision is importable" python3 -c "import torchvision; print(torchvision.__version__)"
check "torchaudio is importable" python3 -c "import torchaudio; print(torchaudio.__version__)"

reportResults
