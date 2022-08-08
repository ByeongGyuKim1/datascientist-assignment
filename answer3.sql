-- ANSWER 3

select auth_year_citation.author_id, auth_year_citation.yearmonth as yearmonth, auth_year_pub.publication_count, auth_year_citation.citation_number
from(
    select auth_paper_year_cit.author_id, auth_paper_year_cit.yearmonth, sum(citation_number) as citation_number
    from(
        select pa.author_id, reference_year_citation.reference_paper_id as paper_id, reference_year_citation.yearmonth, reference_year_citation.citation_number
        from(
            select bothpaper_year.reference_paper_id, bothpaper_year.paper_publish_at as yearmonth, count(reference_paper_id) as citation_number
            from(
                select table1.*, table2.yearmonth as paper_publish_at
                from (
                    select t1.paper_id, t1.reference_paper_id, t2.yearmonth as reference_publish_year  from paper_reference as t1
                    join (select paper_id, substr(published_at, 0, 8) as yearmonth from paper_author) as t2
                    on t1.reference_paper_id == t2.paper_id
                    group by t1.paper_id, t1.reference_paper_id) as table1
                join (select paper_id, substr(published_at, 0, 8) as yearmonth from paper_author) as table2
                on table1.paper_id == table2.paper_id
                group by table1.paper_id, table1.reference_paper_id) as bothpaper_year
            group by bothpaper_year.reference_paper_id, bothpaper_year.paper_publish_at) as reference_year_citation
        join (select author_id, paper_id from paper_author) as pa
        on pa.paper_id == reference_year_citation.reference_paper_id) as auth_paper_year_cit
    group by auth_paper_year_cit.author_id, auth_paper_year_cit.yearmonth) as auth_year_citation
left join (select author_id, substr(published_at,0,8) as yearmonth, count(paper_id) as publication_count from paper_author group by author_id, yearmonth) as auth_year_pub
on auth_year_citation.author_id == auth_year_pub.author_id and auth_year_pub.yearmonth == auth_year_citation.yearmonth
