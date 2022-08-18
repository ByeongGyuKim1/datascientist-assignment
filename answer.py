import pandas as pd


def answer1():
    import pandas as pd

    publish_count = pd.read_csv('paper_author.csv')['author_id'].value_counts().to_frame().reset_index().rename(
        columns={'index': 'author_id', 'author_id': 'publish_count'})
    citation_count = pd.read_csv('paper_reference.csv')[
        'reference_paper_id'].value_counts().to_frame().reset_index().rename(
        columns={"index": "paper_id", "reference_paper_id": "citation_count"})
    sum_cit = pd.read_csv('paper_author.csv')[['author_id', 'paper_id']].merge(citation_count, how="left", left_on='paper_id', right_on='paper_id').groupby("author_id")[
        "citation_count"].sum().to_frame()
    answer = publish_count.merge(sum_cit, how='outer', on='author_id').astype(
        {"author_id": "string", "publish_count": "int", "citation_count": "int"})
    answer


def answer2():
    pass


def answer3():
    pass


def answer4():
    pass


def answer5():
    pass


def answer6():
    pass


def answer7():
    pass


def answer8():
    pass
