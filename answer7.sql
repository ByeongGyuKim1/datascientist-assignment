-- ANSWER 7

select auth_styr_rank.author_id, auth_styr_rank.yearmonth, max(auth_styr_rank.rnk) as h5_index
from (select auth_styr_paper_cit.author_id,
             (substr(auth_styr_paper_cit.standard_yearmonth, 0, 5) || '-' || substr(auth_styr_paper_cit.standard_yearmonth, 5, 2)) as yearmonth,
             auth_styr_paper_cit.citation_count,
             row_number() over (partition by author_id, standard_yearmonth order by citation_count desc) as rnk
      from (select auth_styr_paperid.author_id,
                   cast(auth_styr_paperid.standard_yearmonth as text) as standard_yearmonth,
                   sum(case
                           when standard_yearmonth >= ref_citation_peryear.yearmonth and
                                ref_citation_peryear.yearmonth > standard_yearmonth - 600
                               then ref_citation_peryear.citation_number end) as citation_count
            from (select pa.author_id, styr.yearmonth as standard_yearmonth, pa.paper_id
                  from (select cast(substr(published_at, 0, 5) || substr(published_at, 6, 2) as integer) as yearmonth
                        from paper_author
                        group by yearmonth) as styr
                           left join (select author_id,
                                             paper_id,
                                             cast(substr(published_at, 0, 5) || substr(published_at, 6, 2) as integer) as publish_yearmonth
                                      from paper_author) as pa
                                     on styr.yearmonth >= pa.publish_yearmonth and pa.publish_yearmonth >= styr.yearmonth - 500) as auth_styr_paperid
                     left outer join (select t1.reference_paper_id,
                                             t2.publish_yearmonth   as yearmonth,
                                             count(t1.paper_id) as citation_number
                                      from paper_reference as t1
                                               join (select paper_id,
                                                            cast(substr(published_at, 0, 5) || substr(published_at, 6, 2) as integer) as publish_yearmonth
                                                     from paper_author
                                                     group by paper_id) as t2 on t1.paper_id = t2.paper_id
                                      group by t1.reference_paper_id, t2.publish_yearmonth) as ref_citation_peryear
                                     on ref_citation_peryear.reference_paper_id == auth_styr_paperid.paper_id
            group by auth_styr_paperid.author_id, auth_styr_paperid.standard_yearmonth,
                     auth_styr_paperid.paper_id) as auth_styr_paper_cit) as auth_styr_rank
where auth_styr_rank.citation_count >= auth_styr_rank.rnk
group by auth_styr_rank.author_id, auth_styr_rank.yearmonth

-- 각 저자의 년-월yyyy-MM별 해당 시점에서의 h5-index 를 구하는 쿼리를 작성하세요. (author_id<string>, yearmonth<string>, h5index<int>)
