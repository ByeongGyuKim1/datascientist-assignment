-- 각 저자의 h5-index 를 구하는 쿼리를 작성하세요. (author_id<string>, h5index<int>)

select pa.author_id, h5index
from paper_author as pa