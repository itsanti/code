def find_athlets(
    know_english: list[str],
    sportsmen: list[str],
    more_than_20_years: list[str]
) -> list[str]:
    '''
    В первом списке (know_english) — список тех, кто хорошо владеет английским языком.
    Второй (sportsmen) — содержит имена тех, кто увлекается спортом.
    третий (more_than_20_years) — предоставляет информацию о тех, кто старше 20 лет.

    Функция возвращает список имен студентов, которые подходят под все три критерия.
    '''
    result = (
        set(know_english)
        .intersection(set(sportsmen))
        .intersection(set(more_than_20_years))
    )
    return list(result)
