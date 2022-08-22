import pandas as pd


def answer1():
    publish_count = pd.read_csv('paper_author.csv')['author_id'].value_counts().to_frame().reset_index().rename(
        columns={'index': 'author_id', 'author_id': 'publish_count'})
    citation_count = pd.read_csv('paper_reference.csv')[
        'reference_paper_id'].value_counts().to_frame().reset_index().rename(
        columns={"index": "paper_id", "reference_paper_id": "citation_count"})
    sum_cit = \
    pd.read_csv('paper_author.csv')[['author_id', 'paper_id']].merge(citation_count, how="left", left_on='paper_id',
                                                                     right_on='paper_id').groupby("author_id")[
        "citation_count"].sum().to_frame()
    answer = publish_count.merge(sum_cit, how='outer', on='author_id').astype(
        {"author_id": "string", "publish_count": "int", "citation_count": "int"})


def answer2():
    paper_author_df = pd.read_csv('paper_author.csv')
    paper_reference_df = pd.read_csv('paper_reference.csv')

    paper_author_df['published_year'] = paper_author_df['published_at'].str.slice(start=0, stop=4)
    ref_year = paper_reference_df.merge(paper_author_df[['paper_id', 'published_year']].drop_duplicates(), how='left',
                                        left_on='paper_id', right_on='paper_id')[
        ['reference_paper_id', 'published_year']]
    publish_count = paper_author_df.merge(paper_reference_df, how="left", left_on='paper_id',
                                          right_on='reference_paper_id').groupby(
        ['author_id', 'published_year']).aggregate({'paper_id_x': ['nunique']}).rename(
        columns={'paper_id_x': 'publish_count', 'nunique': ''})
    citation_count = paper_author_df[['author_id', 'paper_id']].merge(ref_year, left_on='paper_id',
                                                                      right_on='reference_paper_id').groupby(
        ['author_id', 'published_year']).aggregate({'published_year': ['count']}).rename(
        columns={'published_year': 'citation_count', 'count': ''})
    publish_count.join(citation_count, how='outer').reset_index().astype(
        {"author_id": "string", "published_year": "int", "publish_count": "int", "citation_count": "int"}).fillna(0)


def answer3():
    paper_author_df = pd.read_csv('paper_author.csv')
    paper_reference_df = pd.read_csv('paper_reference.csv')

    paper_author_df['yearmonth'] = paper_author_df['published_at'].str.slice(start=0, stop=7)
    ref_year = paper_reference_df.merge(paper_author_df[['paper_id', 'yearmonth']].drop_duplicates(), how='left',
                                        left_on='paper_id', right_on='paper_id')[['reference_paper_id', 'yearmonth']]
    publish_count = paper_author_df.merge(paper_reference_df, how="left", left_on='paper_id',
                                          right_on='reference_paper_id').groupby(['author_id', 'yearmonth']).aggregate(
        {'paper_id_x': ['nunique']}).rename(columns={'paper_id_x': 'publish_count', 'nunique': ''})
    citation_count = paper_author_df[['author_id', 'paper_id']].merge(ref_year, left_on='paper_id',
                                                                      right_on='reference_paper_id').groupby(
        ['author_id', 'yearmonth']).aggregate({'yearmonth': ['count']}).rename(
        columns={'yearmonth': 'citation_count', 'count': ''})
    publish_count.join(citation_count, how='outer').reset_index().astype(
        {"author_id": "string", "yearmonth": "int", "publish_count": "int", "citation_count": "int"}).fillna(0)


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
