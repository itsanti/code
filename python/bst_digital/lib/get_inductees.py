from typing import Optional


def get_inductees(
    names: list[str],
    birthday_years: Optional[int],
    genders: Optional[str]
) -> tuple[list[str], list[str]]:
    '''
    В первом списке (names) — имена студентов, позволяющие их точно идентифицировать.
    Во втором (birthday_years) — год рождения.
    В третьем (genders) — пол студента.

    Сформировать список студентов мужского пола, которые достигли возраста 18 лет
    в 2021 году, но при этом не старше 30 лет.

    Отдельно вывести тех, по кому точно нельзя сказать.
    '''
    result = ([], [])
    for student in zip(names, birthday_years, genders):
        if student[2] == 'Female':
            continue
        if (
            student[1] is not None
            and (2021 - student[1] < 18 or 2021 - student[1] > 30)
        ):
            continue
        if None in student:
            result[1].append(student[0])
        else:
            result[0].append(student[0])
    return result
