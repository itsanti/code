from lib.find_athlets import find_athlets
from lib.find_top_20 import find_top_20
from lib.get_inductees import get_inductees
from lib.make_report_about_top3 import make_report_about_top3

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

    know_english = ["Vasya", "Jimmy", "Max", "Peter", "Eric", "Zoi", "Felix"]
    sportsmen = ["Don", "Peter", "Eric", "Jimmy", "Mark"]
    more_than_20_years = ["Peter", "Julie", "Jimmy", "Mark", "Max"]
    print('task 3:', find_athlets(know_english, sportsmen, more_than_20_years))

    students_avg_scores = {
        'Max': 4.964, 'Eric': 4.962, 'Peter': 4.923,
        'Mark': 4.957, 'Julie': 4.95, 'Jimmy': 4.973,
        'Felix': 4.937, 'Vasya': 4.911, 'Don': 4.936, 'Zoi': 4.937
    }
    print('task 4:', make_report_about_top3(students_avg_scores))
