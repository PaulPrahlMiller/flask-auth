"""Module for database actions."""
import sqlite3
from sqlite3 import Error


def create_database(db_path):
    """Create an SQLite database."""
    connection = None
    try:
        connection = sqlite3.connect(db_path)

    except Error as e:
        print(e)

    finally:
        if connection:
            connection.close()
