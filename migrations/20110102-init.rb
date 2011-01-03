#!/bin/bash

commands() {
  cat <<SQL
    begin;

      create table posts(
        id         serial primary key,
        slug       varchar(100) unique not null,
        title      varchar(255) not null,
        content    text not null,
        created_at timestamp not null default now()
      );

      create table tags(
        id   serial primary key,
        name text unique not null
      );

      create table posts_tags(
        post_id integer references posts (id),
        tag_id   integer references tags (id),
        primary key (post_id, tag_id)
      );

      create index index_posts_tags_post_id on posts_tags using btree (post_id);
      create index index_posts_tags_tag_id on posts_tags using btree (tag_id);

    commit;
SQL
}

commands | psql --set ON_ERROR_STOP= blog 2>&1 | grep -v '^\(NOTICE\|BEGIN\|COMMIT\|CREATE\)'
exit $?
