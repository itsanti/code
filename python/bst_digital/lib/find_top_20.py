
def find_top_20(candidates: list[dict]) -> list[str]:
    '''
    Функция принимает на вход список сводной информации по
    абитуриентам (candidates) и возвращает список с именами 20 человек,
    набравших наибольшее СУММАРНОЕ количество баллов (с учетом extra баллов),
    которые станут студентами университета.
    В случае, если не получается однозначно определить 20 человек
    (например, 2 человека набрали одинаковое СУММАРНОЕ количество баллов и
    претендуют на 20 место в списке, стоит их ранжировать по "профильным"
    дисциплинам - "информатике" и "математике").
    '''
    result = []
    for candidate in candidates:
        result.append((
            candidate['name'],
            sum(candidate['scores'].values()) + candidate['extra_scores'],
            candidate['scores']['math'] + candidate['scores']['computer_science']
        ))
    sorted_result = sorted(result, key=lambda x: (x[1], x[2]), reverse=True)
    return [candidate[0] for candidate in sorted_result[:20]]
