"""
Tests for the main module.
"""

from src.{PROJECT_NAME_KEBAB}.main import main


def test_main(capsys) -> None:
    """Test that main function works."""
    main()
    captured = capsys.readouterr()
    assert "Hello from {PROJECT_NAME}!" in captured.out
