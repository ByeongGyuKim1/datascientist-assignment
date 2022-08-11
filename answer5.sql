-- ANSWER 5

select author_id, min(citation_count) as h_index
from(
select auth_paper_cit.*, row_number() over (partition by author_id order by citation_count desc) as rank
from(
    select pa.author_id, pa.paper_id, prc.citation_count as citation_count
    from (select author_id, paper_id, cast(substr(published_at, 0, 5) as integer) as year from paper_author
          where year > cast(substr(date('now'),0,5) as integer) - 5 ) as pa
    left join(
        select pr.reference_paper_id, count(pr.paper_id) as citation_count from paper_reference as pr
        join(
            select paper_id, cast(substr(published_at, 0, 5) as integer) as year from paper_author
            where year > cast(substr(date('now'),0,5) as integer) - 5
            group by paper_id) as paper_pubyear on paper_pubyear.paper_id == pr.paper_id
        group by reference_paper_id) as prc on pa.paper_id == prc.reference_paper_id
    group by pa.author_id, pa.paper_id) as auth_paper_cit) /*저자가 쓴 논문이 몇번 인용되었는지 순서대로 나열*/
where citation_count >= rank
group by author_id

-- 각 저자의 h5-index 를 구하는 쿼리를 작성하세요. (author_id<string>, h5index<int>)
