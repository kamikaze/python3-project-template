import logging

from python3_project_template import c_fib, rust_fib

logger = logging.getLogger(__name__)


def main() -> None:
    msg = f'{c_fib(10)=}'
    logger.info(msg)
    msg = f'{rust_fib(10)=}'
    logger.info(msg)


main()
