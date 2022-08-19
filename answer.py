import pandas as pd


def answer1():
    publish_count = pd.read_csv('paper_author.csv')['author_id'].value_counts().to_frame().reset_index().rename(
        columns={'index': 'author_id', 'author_id': 'publish_count'})
    citation_count = pd.read_csv('paper_reference.csv')[
        'reference_paper_id'].value_counts().to_frame().reset_index().rename(
        columns={"index": "paper_id", "reference_paper_id": "citation_count"})
    sum_cit = pd.read_csv('paper_author.csv')[['author_id', 'paper_id']].merge(citation_count, how="left", left_on='paper_id', right_on='paper_id').groupby("author_id")[
        "citation_count"].sum().to_frame()
    answer = publish_count.merge(sum_cit, how='outer', on='author_id').astype(
        {"author_id": "string", "publish_count": "int", "citation_count": "int"})


def answer2():
    paper_author_df = pd.read_csv('paper_author.csv')
    paper_reference_df = pd.read_csv('paper_reference.csv')

    paper_author_df['published_year'] = paper_author_df['published_at'].str.slice(start=0, stop=4)
    paper_author_df.merge(paper_reference_df, how="left", left_on='paper_id', right_on='reference_paper_id').groupby(['author_id', 'published_year']).aggregate({'paper_id_x': ['nunique'], 'paper_id_y': ['count']})


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
