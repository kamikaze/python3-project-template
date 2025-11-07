
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    dummy_param: str | None = None


settings = Settings()
