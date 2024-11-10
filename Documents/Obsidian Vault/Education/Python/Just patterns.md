<h4>Calculate count line, files and folders in the directory</h4>
```python
import os

__count = 0
__files = 0
__folders = 0

def calculate_count_of_line_in_directory(__dir: str) -> None:
    global __count, __files, __folders

    for f in os.listdir(__dir):
        if os.path.isfile(os.path.join(__dir, f)):
            __files += 1

            try:
                with open(os.path.join(__dir, f), "r") as file:
                    for count, line in enumerate(file):
                        ...

                    __count += count

            except UnicodeDecodeError:
                ...

        elif os.path.isdir(os.path.join(__dir, f)):
            calculate_count_of_line_in_directory(os.path.join(__dir, f))
            __folders += 1

calculate_count_of_line_in_directory("path/to/dir")
print(f"""Lines: {__count - 12000}\nFiles: {__files}\nFolders: {__folders}""")
```

<h3>Singleton</h3>
```python
class Singleton:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(Singleton, cls).__new__(cls, *args, **kwargs)
        return cls._instance


# Using decorator
def singleton(cls):
    instances = {}
    def wrapper(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
    
		return instances[cls]
    return wrapper

@singleton
class Singleton:
    ...
```