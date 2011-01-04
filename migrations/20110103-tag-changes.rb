#!/bin/bash

commands() {
  cat <<SQL
    begin;

      drop table posts_tags;
      drop table tags;

      create table tags (
        post_id integer references posts (id),
        name varchar(20),
        primary key (post_id, name)
      );

      create index index_tags_post_id on tags using btree (post_id);
      create index index_tags_name on tags (name);

    commit;
SQL
}

commands | psql --set ON_ERROR_STOP= blog 2>&1 | grep -v '^\(NOTICE\|BEGIN\|COMMIT\|CREATE\|DROP\)'
exit $?
