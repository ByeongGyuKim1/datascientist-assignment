-- ANSWER 6

select auth_styr_rank.author_id, auth_styr_rank.standard_year as year, max(auth_styr_rank.rank) as h5_index
from (select auth_styr_paper_cit.author_id,
             auth_styr_paper_cit.standard_year,
             auth_styr_paper_cit.citation_count,
             row_number() over (partition by author_id, standard_year order by citation_count desc) as rank
      from (select auth_styr_paperid.author_id,
                   auth_styr_paperid.standard_year,
                   sum(case
                           when standard_year >= ref_citation_peryear.year and
                                ref_citation_peryear.year > standard_year - 5
                               then ref_citation_peryear.citation_number end) as citation_count
            from (select pa.author_id, styr.year as standard_year, pa.paper_id
                  from (select cast(substr(published_at, 0, 5) as integer) as year
                        from paper_author
                        group by year) as styr
                           left join (select author_id,
                                             paper_id,
                                             cast(substr(published_at, 0, 5) as integer) as pub_year
                                      from paper_author) as pa
                                     on styr.year >= pa.pub_year and pa.pub_year > styr.year - 5) as auth_styr_paperid
                     left outer join (select bothpaperid_year.reference_paper_id,
                                             bothpaperid_year.paper_publish_at as year,
                                             count(paper_publish_at)           as citation_number
                                      from (select cast(table2.year as integer) as paper_publish_at,
                                                   table1.reference_paper_id
                                            from (select t1.paper_id,
                                                         t1.reference_paper_id,
                                                         t2.year as reference_publish_year
                                                  from paper_reference as t1
                                                           join (select paper_id, substr(published_at, 0, 5) as year
                                                                 from paper_author) as t2
                                                                on t1.reference_paper_id == t2.paper_id) as table1
                                                     join (select paper_id, substr(published_at, 0, 5) as year
                                                           from paper_author) as table2
                                                          on table1.paper_id == table2.paper_id
                                            group by table1.paper_id, table1.reference_paper_id) as bothpaperid_year
                                      group by reference_paper_id, paper_publish_at) as ref_citation_peryear
                                     on ref_citation_peryear.reference_paper_id == auth_styr_paperid.paper_id
            group by auth_styr_paperid.author_id, auth_styr_paperid.standard_year,
                     auth_styr_paperid.paper_id) as auth_styr_paper_cit) as auth_styr_rank
where auth_styr_rank.citation_count >= auth_styr_rank.rank
group by auth_styr_rank.author_id, auth_styr_rank.standard_year
