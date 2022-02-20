from lib.find_top_20 import find_top_20
from lib.get_inductees import get_inductees

if __name__ == '__main__':
    candidates = [
        {"name": "Vasya", "scores": {"math": 58, "russian_language": 62, "computer_science": 48}, "extra_scores": 0},
        {"name": "Fedya", "scores": {"math": 33, "russian_language": 85, "computer_science": 42}, "extra_scores": 2},
        {"name": "Stepa", "scores": {"math": 91, "russian_language": 34, "computer_science": 34}, "extra_scores": 1},
        {"name": "Petya", "scores": {"math": 92, "russian_language": 33, "computer_science": 34}, "extra_scores": 1}
    ]
    print('task 1:', find_top_20(candidates))

    names = ["Vasya", "Alice", "Petya", "Jenny", "Fedya", "Viola", "Mark", "Chris", "Margo"]
    birthday_years = [1962, 1995, 2000, None, None, None, None, 1998, 2001]
    genders = ["Male", "Female", "Male", "Female", "Male", None, None, None, None]
    print('task 2:', get_inductees(names, birthday_years, genders))