-- ANSWER 1
select author_citation.author_id, author_publication.publication_count, author_citation.citation_count
from(
    select t1.author_id, sum(citation_count) as citation_count
    from(
        select table1.*, table2.citation_count
        from (select author_id, paper_id from paper_author order by author_id) As table1
        join (select reference_paper_id, count(reference_paper_id) as  citation_count from paper_reference group by reference_paper_id) As table2
        on table1.paper_id == table2.reference_paper_id
        ) As t1
    group by t1.author_id
) As author_citation
join (select author_id, count(paper_id) as publication_count from paper_author group by author_id) As author_publication
on author_citation.author_id == author_publication.author_id

