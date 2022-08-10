-- ANSWER 4

select author_id, citation_number as h_index
from(
    select auth_paper_cit.*, row_number() over (partition by author_id order by citation_number desc) as rank
    from(
        select author_id, paper_id, citation_number
        from paper_author
        left join(
            select ref_cit_peryear.reference_paper_id, sum(citation_number) as citation_number
            from (select bothpaperid_year.reference_paper_id, bothpaperid_year.paper_publish_at as year, count(paper_publish_at) as citation_number
                  from (select table1.paper_id, cast(table2.year as integer) as paper_publish_at, table1.reference_paper_id, cast(table1.reference_publish_year as integer) as reference_publish_at
                        from (select t1.paper_id, t1.reference_paper_id, t2.year as reference_publish_year from paper_reference as t1
                              join (select paper_id, substr(published_at, 0, 5) as year from paper_author) as t2
                              on t1.reference_paper_id == t2.paper_id
                              group by t1.paper_id, t1.reference_paper_id) as table1
                        join (select paper_id, substr(published_at, 0, 5) as year from paper_author) as table2
                        on table1.paper_id == table2.paper_id
                        group by table1.paper_id, table1.reference_paper_id) as bothpaperid_year /*paper, ref 각각의 publish 연도*/
                  group by reference_paper_id, paper_publish_at) as ref_cit_peryear /*paper citation per year*/
            group by ref_cit_peryear.reference_paper_id) as ref_cit /*sum all citation*/
        on paper_id == ref_cit.reference_paper_id) as auth_paper_cit) /*저자가 쓴 논문이 몇번 인용되었는지 순서대로 나열*/
where citation_number <= rank + 1
group by author_id

-- author_id<string>, h-index<int>