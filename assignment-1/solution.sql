--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    genreid integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- Name: hasagenre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hasagenre (
    movieid integer NOT NULL,
    genreid integer NOT NULL
);


ALTER TABLE public.hasagenre OWNER TO postgres;

--
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    movieid integer NOT NULL,
    title character varying(255) NOT NULL
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- Name: ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ratings (
    userid integer NOT NULL,
    movieid integer NOT NULL,
    rating numeric(2,1) NOT NULL,
    "timestamp" bigint NOT NULL,
    CONSTRAINT ratings_rating_check CHECK (((rating >= (0)::numeric) AND (rating <= (5)::numeric)))
);


ALTER TABLE public.ratings OWNER TO postgres;

--
-- Name: taginfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taginfo (
    tagid integer NOT NULL,
    content character varying(255) NOT NULL
);


ALTER TABLE public.taginfo OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    userid integer NOT NULL,
    movieid integer NOT NULL,
    tagid integer NOT NULL,
    "timestamp" bigint NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (genreid, name) FROM stdin;
\.


--
-- Data for Name: hasagenre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hasagenre (movieid, genreid) FROM stdin;
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies (movieid, title) FROM stdin;
\.


--
-- Data for Name: ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ratings (userid, movieid, rating, "timestamp") FROM stdin;
\.


--
-- Data for Name: taginfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taginfo (tagid, content) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (userid, movieid, tagid, "timestamp") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (userid, name) FROM stdin;
\.


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genreid);


--
-- Name: hasagenre hasagenre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasagenre
    ADD CONSTRAINT hasagenre_pkey PRIMARY KEY (movieid, genreid);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (movieid);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (userid, movieid);


--
-- Name: taginfo taginfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taginfo
    ADD CONSTRAINT taginfo_pkey PRIMARY KEY (tagid);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (userid, movieid, tagid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: hasagenre hasagenre_genreid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasagenre
    ADD CONSTRAINT hasagenre_genreid_fkey FOREIGN KEY (genreid) REFERENCES public.genres(genreid) ON DELETE CASCADE;


--
-- Name: hasagenre hasagenre_movieid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasagenre
    ADD CONSTRAINT hasagenre_movieid_fkey FOREIGN KEY (movieid) REFERENCES public.movies(movieid) ON DELETE CASCADE;


--
-- Name: ratings ratings_movieid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_movieid_fkey FOREIGN KEY (movieid) REFERENCES public.movies(movieid) ON DELETE CASCADE;


--
-- Name: ratings ratings_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT ratings_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: tags tags_movieid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_movieid_fkey FOREIGN KEY (movieid) REFERENCES public.movies(movieid) ON DELETE CASCADE;


--
-- Name: tags tags_tagid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tagid_fkey FOREIGN KEY (tagid) REFERENCES public.taginfo(tagid) ON DELETE CASCADE;


--
-- Name: tags tags_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

