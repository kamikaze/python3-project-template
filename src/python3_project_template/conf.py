from typing import Optional

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    dummy_param: Optional[str] = None


settings = Settings()
