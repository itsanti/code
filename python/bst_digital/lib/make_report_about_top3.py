import os

from openpyxl import Workbook
from openpyxl.styles import Font


def make_report_about_top3(students_avg_scores: dict[str, float]) -> str:
    '''
    словарь (students_avg_scores), в котором ключами являются имена студентов,
    а значениями — средний балл за всю учебу.

    Функция находит ТОП-3 студентов, чей средний балл выше, чем у других.
    Функция возвращает ссылку на эксель-файл с этими студентами.
    Сам файл необходимо создать внутри функции.
    '''
    top3_students = sorted(
        students_avg_scores,
        key=lambda x: students_avg_scores[x],
        reverse=True
    )[:3]
    input_data = {
        name: students_avg_scores[name] for name in top3_students
    }
    return make_xlsx(input_data, 'Top3 report', ['student', 'avg_score'])


def make_xlsx(
    input_data: dict[str, float],
    title: str,
    header: list[str]
) -> str:
    filename = title.lower().replace(' ', '_') + '.xlsx'
    filename = os.path.join('data', filename)
    wb = Workbook()
    ws = wb.active
    ws.title = title
    ft = Font(bold=True)
    for ix, value in enumerate(header):
        cell = ws.cell(1, ix + 1)
        cell.value = value
        cell.font = ft
    for item in input_data.items():
        ws.append(item)
    wb.save(filename)
    return os.path.abspath(filename)
