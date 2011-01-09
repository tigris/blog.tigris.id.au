#!/bin/bash

commands() {
  cat <<SQL
    begin;

      create table posts (
        id         serial primary key,
        slug       varchar(100) unique not null,
        title      varchar(255) not null,
        summary    text not null,
        content    text not null,
        created_at timestamp not null default now()
      );

      create table tags (
        post_id integer references posts (id) on delete cascade,
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
