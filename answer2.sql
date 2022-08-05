-- ANSWER 2
-- (author_id<string>, year<int>, publication_count<int>, citation_count<int>)

/*
SELECT pa.author_id,
       substr(pa.published_at,0,5),
    count(distinct pa.paper_id) as publication_count,
    count(pr.paper_id) as citation_count
FROM paper_author as pa
JOIN paper_reference as pr on pa.paper_id = pr.reference_paper_id
GROUP BY pa.author_id
ORDER BY publication_count DESC;
*/
select auth_year_citation.author_id, auth_year_citation.year, auth_year_pub.publication_count, auth_year_citation.citation_count
from(
    select auth_paper_year_cit.author_id, auth_paper_year_cit.year, sum(citation_count) as citation_count
    from(
        select table1.*, table2.citation_count
        from (select author_id, paper_id, substr(published_at,0,5) as year from paper_author order by author_id) as table1
        join (select reference_paper_id, count(reference_paper_id) as  citation_count from paper_reference group by reference_paper_id) as table2
        on table1.paper_id == table2.reference_paper_id
        ) as auth_paper_year_cit
    group by auth_paper_year_cit.author_id, auth_paper_year_cit.year
) as auth_year_citation
join (select author_id, substr(published_at,0,5) as year, count(paper_id) as publication_count from paper_author group by author_id, year) as auth_year_pub
on auth_year_citation.author_id == auth_year_pub.author_id and auth_year_pub.year == auth_year_citation.year;
