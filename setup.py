import sys

from pkg_resources import VersionConflict, require
from setuptools import setup, Extension
from setuptools_rust import Binding, RustExtension

try:
    require('setuptools>=78.0')
except VersionConflict:
    print('Error: version of setuptools is too old (<78.0)!')
    sys.exit(1)

if __name__ == '__main__':
    setup(
        ext_modules=[
            Extension(
                'python3_project_template._cmod',
                ['clib/lib.c'],
                include_dirs=['clib'],
                py_limited_api=True
            ),
        ],
        rust_extensions=[
            RustExtension(
                'python3_project_template._rustmod',
                'rustlib/Cargo.toml',
                binding=Binding.PyO3
            ),
        ],
    )
