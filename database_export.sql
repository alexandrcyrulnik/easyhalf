--
-- PostgreSQL database dump
--

\restrict vuQBA0PjIROGQkYChgb0h1KkUUhpcYJlBMGucZgi4Adt4dI7zCfwEBtezKyGdQ4

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

--
-- Name: stripe; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA stripe;


ALTER SCHEMA stripe OWNER TO postgres;

--
-- Name: invoice_status; Type: TYPE; Schema: stripe; Owner: postgres
--

CREATE TYPE stripe.invoice_status AS ENUM (
    'draft',
    'open',
    'paid',
    'uncollectible',
    'void',
    'deleted'
);


ALTER TYPE stripe.invoice_status OWNER TO postgres;

--
-- Name: pricing_tiers; Type: TYPE; Schema: stripe; Owner: postgres
--

CREATE TYPE stripe.pricing_tiers AS ENUM (
    'graduated',
    'volume'
);


ALTER TYPE stripe.pricing_tiers OWNER TO postgres;

--
-- Name: pricing_type; Type: TYPE; Schema: stripe; Owner: postgres
--

CREATE TYPE stripe.pricing_type AS ENUM (
    'one_time',
    'recurring'
);


ALTER TYPE stripe.pricing_type OWNER TO postgres;

--
-- Name: subscription_schedule_status; Type: TYPE; Schema: stripe; Owner: postgres
--

CREATE TYPE stripe.subscription_schedule_status AS ENUM (
    'not_started',
    'active',
    'completed',
    'released',
    'canceled'
);


ALTER TYPE stripe.subscription_schedule_status OWNER TO postgres;

--
-- Name: subscription_status; Type: TYPE; Schema: stripe; Owner: postgres
--

CREATE TYPE stripe.subscription_status AS ENUM (
    'trialing',
    'active',
    'canceled',
    'incomplete',
    'incomplete_expired',
    'past_due',
    'unpaid',
    'paused'
);


ALTER TYPE stripe.subscription_status OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new._updated_at = now();
  return NEW;
end;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

--
-- Name: set_updated_at_metadata(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at_metadata() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = now();
  return NEW;
end;
$$;


ALTER FUNCTION public.set_updated_at_metadata() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_tokens (
    token character varying(32) NOT NULL,
    plan_type character varying(10) NOT NULL,
    used boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    used_at timestamp without time zone
);


ALTER TABLE public.customer_tokens OWNER TO postgres;

--
-- Name: paid_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paid_orders (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    stripe_session_id character varying(255) NOT NULL,
    token character varying(32) NOT NULL,
    plan_type character varying(10) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.paid_orders OWNER TO postgres;

--
-- Name: paid_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paid_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paid_orders_id_seq OWNER TO postgres;

--
-- Name: paid_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paid_orders_id_seq OWNED BY public.paid_orders.id;


--
-- Name: trial_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trial_tokens (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255),
    plan_type character varying(10) NOT NULL,
    gender character varying(50),
    age character varying(50),
    experience character varying(100),
    weekly_distance character varying(100),
    current_pace character varying(100),
    longest_run character varying(100),
    goal character varying(100),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    access_count integer NOT NULL
);


ALTER TABLE public.trial_tokens OWNER TO postgres;

--
-- Name: trial_tokens_access_count_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trial_tokens_access_count_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trial_tokens_access_count_seq OWNER TO postgres;

--
-- Name: trial_tokens_access_count_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trial_tokens_access_count_seq OWNED BY public.trial_tokens.access_count;


--
-- Name: trial_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trial_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trial_tokens_id_seq OWNER TO postgres;

--
-- Name: trial_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trial_tokens_id_seq OWNED BY public.trial_tokens.id;


--
-- Name: _managed_webhooks; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe._managed_webhooks (
    id text NOT NULL,
    object text,
    url text NOT NULL,
    enabled_events jsonb NOT NULL,
    description text,
    enabled boolean,
    livemode boolean,
    metadata jsonb,
    secret text NOT NULL,
    status text,
    api_version text,
    created integer,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    last_synced_at timestamp with time zone,
    account_id text NOT NULL
);


ALTER TABLE stripe._managed_webhooks OWNER TO postgres;

--
-- Name: _migrations; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe._migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE stripe._migrations OWNER TO postgres;

--
-- Name: _sync_status; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe._sync_status (
    id integer NOT NULL,
    resource text NOT NULL,
    status text DEFAULT 'idle'::text,
    last_synced_at timestamp with time zone DEFAULT now(),
    last_incremental_cursor timestamp with time zone,
    error_message text,
    updated_at timestamp with time zone DEFAULT now(),
    account_id text NOT NULL,
    CONSTRAINT _sync_status_status_check CHECK ((status = ANY (ARRAY['idle'::text, 'running'::text, 'complete'::text, 'error'::text])))
);


ALTER TABLE stripe._sync_status OWNER TO postgres;

--
-- Name: _sync_status_id_seq; Type: SEQUENCE; Schema: stripe; Owner: postgres
--

CREATE SEQUENCE stripe._sync_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE stripe._sync_status_id_seq OWNER TO postgres;

--
-- Name: _sync_status_id_seq; Type: SEQUENCE OWNED BY; Schema: stripe; Owner: postgres
--

ALTER SEQUENCE stripe._sync_status_id_seq OWNED BY stripe._sync_status.id;


--
-- Name: accounts; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.accounts (
    _raw_data jsonb NOT NULL,
    first_synced_at timestamp with time zone DEFAULT now() NOT NULL,
    _last_synced_at timestamp with time zone DEFAULT now() NOT NULL,
    _updated_at timestamp with time zone DEFAULT now() NOT NULL,
    business_name text GENERATED ALWAYS AS (((_raw_data -> 'business_profile'::text) ->> 'name'::text)) STORED,
    email text GENERATED ALWAYS AS ((_raw_data ->> 'email'::text)) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    charges_enabled boolean GENERATED ALWAYS AS (((_raw_data ->> 'charges_enabled'::text))::boolean) STORED,
    payouts_enabled boolean GENERATED ALWAYS AS (((_raw_data ->> 'payouts_enabled'::text))::boolean) STORED,
    details_submitted boolean GENERATED ALWAYS AS (((_raw_data ->> 'details_submitted'::text))::boolean) STORED,
    country text GENERATED ALWAYS AS ((_raw_data ->> 'country'::text)) STORED,
    default_currency text GENERATED ALWAYS AS ((_raw_data ->> 'default_currency'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    api_key_hashes text[] DEFAULT '{}'::text[],
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.accounts OWNER TO postgres;

--
-- Name: active_entitlements; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.active_entitlements (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    feature text GENERATED ALWAYS AS ((_raw_data ->> 'feature'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    lookup_key text GENERATED ALWAYS AS ((_raw_data ->> 'lookup_key'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.active_entitlements OWNER TO postgres;

--
-- Name: charges; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.charges (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    paid boolean GENERATED ALWAYS AS (((_raw_data ->> 'paid'::text))::boolean) STORED,
    "order" text GENERATED ALWAYS AS ((_raw_data ->> 'order'::text)) STORED,
    amount bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::bigint) STORED,
    review text GENERATED ALWAYS AS ((_raw_data ->> 'review'::text)) STORED,
    source jsonb GENERATED ALWAYS AS ((_raw_data -> 'source'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    dispute text GENERATED ALWAYS AS ((_raw_data ->> 'dispute'::text)) STORED,
    invoice text GENERATED ALWAYS AS ((_raw_data ->> 'invoice'::text)) STORED,
    outcome jsonb GENERATED ALWAYS AS ((_raw_data -> 'outcome'::text)) STORED,
    refunds jsonb GENERATED ALWAYS AS ((_raw_data -> 'refunds'::text)) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    captured boolean GENERATED ALWAYS AS (((_raw_data ->> 'captured'::text))::boolean) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    refunded boolean GENERATED ALWAYS AS (((_raw_data ->> 'refunded'::text))::boolean) STORED,
    shipping jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping'::text)) STORED,
    application text GENERATED ALWAYS AS ((_raw_data ->> 'application'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    destination text GENERATED ALWAYS AS ((_raw_data ->> 'destination'::text)) STORED,
    failure_code text GENERATED ALWAYS AS ((_raw_data ->> 'failure_code'::text)) STORED,
    on_behalf_of text GENERATED ALWAYS AS ((_raw_data ->> 'on_behalf_of'::text)) STORED,
    fraud_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'fraud_details'::text)) STORED,
    receipt_email text GENERATED ALWAYS AS ((_raw_data ->> 'receipt_email'::text)) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    receipt_number text GENERATED ALWAYS AS ((_raw_data ->> 'receipt_number'::text)) STORED,
    transfer_group text GENERATED ALWAYS AS ((_raw_data ->> 'transfer_group'::text)) STORED,
    amount_refunded bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount_refunded'::text))::bigint) STORED,
    application_fee text GENERATED ALWAYS AS ((_raw_data ->> 'application_fee'::text)) STORED,
    failure_message text GENERATED ALWAYS AS ((_raw_data ->> 'failure_message'::text)) STORED,
    source_transfer text GENERATED ALWAYS AS ((_raw_data ->> 'source_transfer'::text)) STORED,
    balance_transaction text GENERATED ALWAYS AS ((_raw_data ->> 'balance_transaction'::text)) STORED,
    statement_descriptor text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor'::text)) STORED,
    payment_method_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_method_details'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.charges OWNER TO postgres;

--
-- Name: checkout_session_line_items; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.checkout_session_line_items (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    amount_discount integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_discount'::text))::integer) STORED,
    amount_subtotal integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_subtotal'::text))::integer) STORED,
    amount_tax integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_tax'::text))::integer) STORED,
    amount_total integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_total'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    price text GENERATED ALWAYS AS ((_raw_data ->> 'price'::text)) STORED,
    quantity integer GENERATED ALWAYS AS (((_raw_data ->> 'quantity'::text))::integer) STORED,
    checkout_session text GENERATED ALWAYS AS ((_raw_data ->> 'checkout_session'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.checkout_session_line_items OWNER TO postgres;

--
-- Name: checkout_sessions; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.checkout_sessions (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    adaptive_pricing jsonb GENERATED ALWAYS AS ((_raw_data -> 'adaptive_pricing'::text)) STORED,
    after_expiration jsonb GENERATED ALWAYS AS ((_raw_data -> 'after_expiration'::text)) STORED,
    allow_promotion_codes boolean GENERATED ALWAYS AS (((_raw_data ->> 'allow_promotion_codes'::text))::boolean) STORED,
    amount_subtotal integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_subtotal'::text))::integer) STORED,
    amount_total integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_total'::text))::integer) STORED,
    automatic_tax jsonb GENERATED ALWAYS AS ((_raw_data -> 'automatic_tax'::text)) STORED,
    billing_address_collection text GENERATED ALWAYS AS ((_raw_data ->> 'billing_address_collection'::text)) STORED,
    cancel_url text GENERATED ALWAYS AS ((_raw_data ->> 'cancel_url'::text)) STORED,
    client_reference_id text GENERATED ALWAYS AS ((_raw_data ->> 'client_reference_id'::text)) STORED,
    client_secret text GENERATED ALWAYS AS ((_raw_data ->> 'client_secret'::text)) STORED,
    collected_information jsonb GENERATED ALWAYS AS ((_raw_data -> 'collected_information'::text)) STORED,
    consent jsonb GENERATED ALWAYS AS ((_raw_data -> 'consent'::text)) STORED,
    consent_collection jsonb GENERATED ALWAYS AS ((_raw_data -> 'consent_collection'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    currency_conversion jsonb GENERATED ALWAYS AS ((_raw_data -> 'currency_conversion'::text)) STORED,
    custom_fields jsonb GENERATED ALWAYS AS ((_raw_data -> 'custom_fields'::text)) STORED,
    custom_text jsonb GENERATED ALWAYS AS ((_raw_data -> 'custom_text'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    customer_creation text GENERATED ALWAYS AS ((_raw_data ->> 'customer_creation'::text)) STORED,
    customer_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'customer_details'::text)) STORED,
    customer_email text GENERATED ALWAYS AS ((_raw_data ->> 'customer_email'::text)) STORED,
    discounts jsonb GENERATED ALWAYS AS ((_raw_data -> 'discounts'::text)) STORED,
    expires_at integer GENERATED ALWAYS AS (((_raw_data ->> 'expires_at'::text))::integer) STORED,
    invoice text GENERATED ALWAYS AS ((_raw_data ->> 'invoice'::text)) STORED,
    invoice_creation jsonb GENERATED ALWAYS AS ((_raw_data -> 'invoice_creation'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    locale text GENERATED ALWAYS AS ((_raw_data ->> 'locale'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    mode text GENERATED ALWAYS AS ((_raw_data ->> 'mode'::text)) STORED,
    optional_items jsonb GENERATED ALWAYS AS ((_raw_data -> 'optional_items'::text)) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    payment_link text GENERATED ALWAYS AS ((_raw_data ->> 'payment_link'::text)) STORED,
    payment_method_collection text GENERATED ALWAYS AS ((_raw_data ->> 'payment_method_collection'::text)) STORED,
    payment_method_configuration_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_method_configuration_details'::text)) STORED,
    payment_method_options jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_method_options'::text)) STORED,
    payment_method_types jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_method_types'::text)) STORED,
    payment_status text GENERATED ALWAYS AS ((_raw_data ->> 'payment_status'::text)) STORED,
    permissions jsonb GENERATED ALWAYS AS ((_raw_data -> 'permissions'::text)) STORED,
    phone_number_collection jsonb GENERATED ALWAYS AS ((_raw_data -> 'phone_number_collection'::text)) STORED,
    presentment_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'presentment_details'::text)) STORED,
    recovered_from text GENERATED ALWAYS AS ((_raw_data ->> 'recovered_from'::text)) STORED,
    redirect_on_completion text GENERATED ALWAYS AS ((_raw_data ->> 'redirect_on_completion'::text)) STORED,
    return_url text GENERATED ALWAYS AS ((_raw_data ->> 'return_url'::text)) STORED,
    saved_payment_method_options jsonb GENERATED ALWAYS AS ((_raw_data -> 'saved_payment_method_options'::text)) STORED,
    setup_intent text GENERATED ALWAYS AS ((_raw_data ->> 'setup_intent'::text)) STORED,
    shipping_address_collection jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping_address_collection'::text)) STORED,
    shipping_cost jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping_cost'::text)) STORED,
    shipping_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping_details'::text)) STORED,
    shipping_options jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping_options'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    submit_type text GENERATED ALWAYS AS ((_raw_data ->> 'submit_type'::text)) STORED,
    subscription text GENERATED ALWAYS AS ((_raw_data ->> 'subscription'::text)) STORED,
    success_url text GENERATED ALWAYS AS ((_raw_data ->> 'success_url'::text)) STORED,
    tax_id_collection jsonb GENERATED ALWAYS AS ((_raw_data -> 'tax_id_collection'::text)) STORED,
    total_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'total_details'::text)) STORED,
    ui_mode text GENERATED ALWAYS AS ((_raw_data ->> 'ui_mode'::text)) STORED,
    url text GENERATED ALWAYS AS ((_raw_data ->> 'url'::text)) STORED,
    wallet_options jsonb GENERATED ALWAYS AS ((_raw_data -> 'wallet_options'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.checkout_sessions OWNER TO postgres;

--
-- Name: coupons; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.coupons (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    name text GENERATED ALWAYS AS ((_raw_data ->> 'name'::text)) STORED,
    valid boolean GENERATED ALWAYS AS (((_raw_data ->> 'valid'::text))::boolean) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    duration text GENERATED ALWAYS AS ((_raw_data ->> 'duration'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    redeem_by integer GENERATED ALWAYS AS (((_raw_data ->> 'redeem_by'::text))::integer) STORED,
    amount_off bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount_off'::text))::bigint) STORED,
    percent_off double precision GENERATED ALWAYS AS (((_raw_data ->> 'percent_off'::text))::double precision) STORED,
    times_redeemed bigint GENERATED ALWAYS AS (((_raw_data ->> 'times_redeemed'::text))::bigint) STORED,
    max_redemptions bigint GENERATED ALWAYS AS (((_raw_data ->> 'max_redemptions'::text))::bigint) STORED,
    duration_in_months bigint GENERATED ALWAYS AS (((_raw_data ->> 'duration_in_months'::text))::bigint) STORED,
    percent_off_precise double precision GENERATED ALWAYS AS (((_raw_data ->> 'percent_off_precise'::text))::double precision) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.coupons OWNER TO postgres;

--
-- Name: credit_notes; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.credit_notes (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    amount integer GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::integer) STORED,
    amount_shipping integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_shipping'::text))::integer) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    customer_balance_transaction text GENERATED ALWAYS AS ((_raw_data ->> 'customer_balance_transaction'::text)) STORED,
    discount_amount integer GENERATED ALWAYS AS (((_raw_data ->> 'discount_amount'::text))::integer) STORED,
    discount_amounts jsonb GENERATED ALWAYS AS ((_raw_data -> 'discount_amounts'::text)) STORED,
    invoice text GENERATED ALWAYS AS ((_raw_data ->> 'invoice'::text)) STORED,
    lines jsonb GENERATED ALWAYS AS ((_raw_data -> 'lines'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    memo text GENERATED ALWAYS AS ((_raw_data ->> 'memo'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    number text GENERATED ALWAYS AS ((_raw_data ->> 'number'::text)) STORED,
    out_of_band_amount integer GENERATED ALWAYS AS (((_raw_data ->> 'out_of_band_amount'::text))::integer) STORED,
    pdf text GENERATED ALWAYS AS ((_raw_data ->> 'pdf'::text)) STORED,
    reason text GENERATED ALWAYS AS ((_raw_data ->> 'reason'::text)) STORED,
    refund text GENERATED ALWAYS AS ((_raw_data ->> 'refund'::text)) STORED,
    shipping_cost jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping_cost'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    subtotal integer GENERATED ALWAYS AS (((_raw_data ->> 'subtotal'::text))::integer) STORED,
    subtotal_excluding_tax integer GENERATED ALWAYS AS (((_raw_data ->> 'subtotal_excluding_tax'::text))::integer) STORED,
    tax_amounts jsonb GENERATED ALWAYS AS ((_raw_data -> 'tax_amounts'::text)) STORED,
    total integer GENERATED ALWAYS AS (((_raw_data ->> 'total'::text))::integer) STORED,
    total_excluding_tax integer GENERATED ALWAYS AS (((_raw_data ->> 'total_excluding_tax'::text))::integer) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    voided_at text GENERATED ALWAYS AS ((_raw_data ->> 'voided_at'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.credit_notes OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.customers (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    address jsonb GENERATED ALWAYS AS ((_raw_data -> 'address'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    email text GENERATED ALWAYS AS ((_raw_data ->> 'email'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    name text GENERATED ALWAYS AS ((_raw_data ->> 'name'::text)) STORED,
    phone text GENERATED ALWAYS AS ((_raw_data ->> 'phone'::text)) STORED,
    shipping jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping'::text)) STORED,
    balance integer GENERATED ALWAYS AS (((_raw_data ->> 'balance'::text))::integer) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    default_source text GENERATED ALWAYS AS ((_raw_data ->> 'default_source'::text)) STORED,
    delinquent boolean GENERATED ALWAYS AS (((_raw_data ->> 'delinquent'::text))::boolean) STORED,
    discount jsonb GENERATED ALWAYS AS ((_raw_data -> 'discount'::text)) STORED,
    invoice_prefix text GENERATED ALWAYS AS ((_raw_data ->> 'invoice_prefix'::text)) STORED,
    invoice_settings jsonb GENERATED ALWAYS AS ((_raw_data -> 'invoice_settings'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    next_invoice_sequence integer GENERATED ALWAYS AS (((_raw_data ->> 'next_invoice_sequence'::text))::integer) STORED,
    preferred_locales jsonb GENERATED ALWAYS AS ((_raw_data -> 'preferred_locales'::text)) STORED,
    tax_exempt text GENERATED ALWAYS AS ((_raw_data ->> 'tax_exempt'::text)) STORED,
    deleted boolean GENERATED ALWAYS AS (((_raw_data ->> 'deleted'::text))::boolean) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.customers OWNER TO postgres;

--
-- Name: disputes; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.disputes (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    amount bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::bigint) STORED,
    charge text GENERATED ALWAYS AS ((_raw_data ->> 'charge'::text)) STORED,
    reason text GENERATED ALWAYS AS ((_raw_data ->> 'reason'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    evidence jsonb GENERATED ALWAYS AS ((_raw_data -> 'evidence'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    evidence_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'evidence_details'::text)) STORED,
    balance_transactions jsonb GENERATED ALWAYS AS ((_raw_data -> 'balance_transactions'::text)) STORED,
    is_charge_refundable boolean GENERATED ALWAYS AS (((_raw_data ->> 'is_charge_refundable'::text))::boolean) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.disputes OWNER TO postgres;

--
-- Name: early_fraud_warnings; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.early_fraud_warnings (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    actionable boolean GENERATED ALWAYS AS (((_raw_data ->> 'actionable'::text))::boolean) STORED,
    charge text GENERATED ALWAYS AS ((_raw_data ->> 'charge'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    fraud_type text GENERATED ALWAYS AS ((_raw_data ->> 'fraud_type'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.early_fraud_warnings OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.events (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    data jsonb GENERATED ALWAYS AS ((_raw_data -> 'data'::text)) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    request text GENERATED ALWAYS AS ((_raw_data ->> 'request'::text)) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    api_version text GENERATED ALWAYS AS ((_raw_data ->> 'api_version'::text)) STORED,
    pending_webhooks bigint GENERATED ALWAYS AS (((_raw_data ->> 'pending_webhooks'::text))::bigint) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.events OWNER TO postgres;

--
-- Name: features; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.features (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    name text GENERATED ALWAYS AS ((_raw_data ->> 'name'::text)) STORED,
    lookup_key text GENERATED ALWAYS AS ((_raw_data ->> 'lookup_key'::text)) STORED,
    active boolean GENERATED ALWAYS AS (((_raw_data ->> 'active'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.features OWNER TO postgres;

--
-- Name: invoices; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.invoices (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    auto_advance boolean GENERATED ALWAYS AS (((_raw_data ->> 'auto_advance'::text))::boolean) STORED,
    collection_method text GENERATED ALWAYS AS ((_raw_data ->> 'collection_method'::text)) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    hosted_invoice_url text GENERATED ALWAYS AS ((_raw_data ->> 'hosted_invoice_url'::text)) STORED,
    lines jsonb GENERATED ALWAYS AS ((_raw_data -> 'lines'::text)) STORED,
    period_end integer GENERATED ALWAYS AS (((_raw_data ->> 'period_end'::text))::integer) STORED,
    period_start integer GENERATED ALWAYS AS (((_raw_data ->> 'period_start'::text))::integer) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    total bigint GENERATED ALWAYS AS (((_raw_data ->> 'total'::text))::bigint) STORED,
    account_country text GENERATED ALWAYS AS ((_raw_data ->> 'account_country'::text)) STORED,
    account_name text GENERATED ALWAYS AS ((_raw_data ->> 'account_name'::text)) STORED,
    account_tax_ids jsonb GENERATED ALWAYS AS ((_raw_data -> 'account_tax_ids'::text)) STORED,
    amount_due bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount_due'::text))::bigint) STORED,
    amount_paid bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount_paid'::text))::bigint) STORED,
    amount_remaining bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount_remaining'::text))::bigint) STORED,
    application_fee_amount bigint GENERATED ALWAYS AS (((_raw_data ->> 'application_fee_amount'::text))::bigint) STORED,
    attempt_count integer GENERATED ALWAYS AS (((_raw_data ->> 'attempt_count'::text))::integer) STORED,
    attempted boolean GENERATED ALWAYS AS (((_raw_data ->> 'attempted'::text))::boolean) STORED,
    billing_reason text GENERATED ALWAYS AS ((_raw_data ->> 'billing_reason'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    custom_fields jsonb GENERATED ALWAYS AS ((_raw_data -> 'custom_fields'::text)) STORED,
    customer_address jsonb GENERATED ALWAYS AS ((_raw_data -> 'customer_address'::text)) STORED,
    customer_email text GENERATED ALWAYS AS ((_raw_data ->> 'customer_email'::text)) STORED,
    customer_name text GENERATED ALWAYS AS ((_raw_data ->> 'customer_name'::text)) STORED,
    customer_phone text GENERATED ALWAYS AS ((_raw_data ->> 'customer_phone'::text)) STORED,
    customer_shipping jsonb GENERATED ALWAYS AS ((_raw_data -> 'customer_shipping'::text)) STORED,
    customer_tax_exempt text GENERATED ALWAYS AS ((_raw_data ->> 'customer_tax_exempt'::text)) STORED,
    customer_tax_ids jsonb GENERATED ALWAYS AS ((_raw_data -> 'customer_tax_ids'::text)) STORED,
    default_tax_rates jsonb GENERATED ALWAYS AS ((_raw_data -> 'default_tax_rates'::text)) STORED,
    discount jsonb GENERATED ALWAYS AS ((_raw_data -> 'discount'::text)) STORED,
    discounts jsonb GENERATED ALWAYS AS ((_raw_data -> 'discounts'::text)) STORED,
    due_date integer GENERATED ALWAYS AS (((_raw_data ->> 'due_date'::text))::integer) STORED,
    ending_balance integer GENERATED ALWAYS AS (((_raw_data ->> 'ending_balance'::text))::integer) STORED,
    footer text GENERATED ALWAYS AS ((_raw_data ->> 'footer'::text)) STORED,
    invoice_pdf text GENERATED ALWAYS AS ((_raw_data ->> 'invoice_pdf'::text)) STORED,
    last_finalization_error jsonb GENERATED ALWAYS AS ((_raw_data -> 'last_finalization_error'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    next_payment_attempt integer GENERATED ALWAYS AS (((_raw_data ->> 'next_payment_attempt'::text))::integer) STORED,
    number text GENERATED ALWAYS AS ((_raw_data ->> 'number'::text)) STORED,
    paid boolean GENERATED ALWAYS AS (((_raw_data ->> 'paid'::text))::boolean) STORED,
    payment_settings jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_settings'::text)) STORED,
    post_payment_credit_notes_amount integer GENERATED ALWAYS AS (((_raw_data ->> 'post_payment_credit_notes_amount'::text))::integer) STORED,
    pre_payment_credit_notes_amount integer GENERATED ALWAYS AS (((_raw_data ->> 'pre_payment_credit_notes_amount'::text))::integer) STORED,
    receipt_number text GENERATED ALWAYS AS ((_raw_data ->> 'receipt_number'::text)) STORED,
    starting_balance integer GENERATED ALWAYS AS (((_raw_data ->> 'starting_balance'::text))::integer) STORED,
    statement_descriptor text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor'::text)) STORED,
    status_transitions jsonb GENERATED ALWAYS AS ((_raw_data -> 'status_transitions'::text)) STORED,
    subtotal integer GENERATED ALWAYS AS (((_raw_data ->> 'subtotal'::text))::integer) STORED,
    tax integer GENERATED ALWAYS AS (((_raw_data ->> 'tax'::text))::integer) STORED,
    total_discount_amounts jsonb GENERATED ALWAYS AS ((_raw_data -> 'total_discount_amounts'::text)) STORED,
    total_tax_amounts jsonb GENERATED ALWAYS AS ((_raw_data -> 'total_tax_amounts'::text)) STORED,
    transfer_data jsonb GENERATED ALWAYS AS ((_raw_data -> 'transfer_data'::text)) STORED,
    webhooks_delivered_at integer GENERATED ALWAYS AS (((_raw_data ->> 'webhooks_delivered_at'::text))::integer) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    subscription text GENERATED ALWAYS AS ((_raw_data ->> 'subscription'::text)) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    default_payment_method text GENERATED ALWAYS AS ((_raw_data ->> 'default_payment_method'::text)) STORED,
    default_source text GENERATED ALWAYS AS ((_raw_data ->> 'default_source'::text)) STORED,
    on_behalf_of text GENERATED ALWAYS AS ((_raw_data ->> 'on_behalf_of'::text)) STORED,
    charge text GENERATED ALWAYS AS ((_raw_data ->> 'charge'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.invoices OWNER TO postgres;

--
-- Name: payment_intents; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.payment_intents (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    amount integer GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::integer) STORED,
    amount_capturable integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_capturable'::text))::integer) STORED,
    amount_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'amount_details'::text)) STORED,
    amount_received integer GENERATED ALWAYS AS (((_raw_data ->> 'amount_received'::text))::integer) STORED,
    application text GENERATED ALWAYS AS ((_raw_data ->> 'application'::text)) STORED,
    application_fee_amount integer GENERATED ALWAYS AS (((_raw_data ->> 'application_fee_amount'::text))::integer) STORED,
    automatic_payment_methods text GENERATED ALWAYS AS ((_raw_data ->> 'automatic_payment_methods'::text)) STORED,
    canceled_at integer GENERATED ALWAYS AS (((_raw_data ->> 'canceled_at'::text))::integer) STORED,
    cancellation_reason text GENERATED ALWAYS AS ((_raw_data ->> 'cancellation_reason'::text)) STORED,
    capture_method text GENERATED ALWAYS AS ((_raw_data ->> 'capture_method'::text)) STORED,
    client_secret text GENERATED ALWAYS AS ((_raw_data ->> 'client_secret'::text)) STORED,
    confirmation_method text GENERATED ALWAYS AS ((_raw_data ->> 'confirmation_method'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    invoice text GENERATED ALWAYS AS ((_raw_data ->> 'invoice'::text)) STORED,
    last_payment_error text GENERATED ALWAYS AS ((_raw_data ->> 'last_payment_error'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    next_action text GENERATED ALWAYS AS ((_raw_data ->> 'next_action'::text)) STORED,
    on_behalf_of text GENERATED ALWAYS AS ((_raw_data ->> 'on_behalf_of'::text)) STORED,
    payment_method text GENERATED ALWAYS AS ((_raw_data ->> 'payment_method'::text)) STORED,
    payment_method_options jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_method_options'::text)) STORED,
    payment_method_types jsonb GENERATED ALWAYS AS ((_raw_data -> 'payment_method_types'::text)) STORED,
    processing text GENERATED ALWAYS AS ((_raw_data ->> 'processing'::text)) STORED,
    receipt_email text GENERATED ALWAYS AS ((_raw_data ->> 'receipt_email'::text)) STORED,
    review text GENERATED ALWAYS AS ((_raw_data ->> 'review'::text)) STORED,
    setup_future_usage text GENERATED ALWAYS AS ((_raw_data ->> 'setup_future_usage'::text)) STORED,
    shipping jsonb GENERATED ALWAYS AS ((_raw_data -> 'shipping'::text)) STORED,
    statement_descriptor text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor'::text)) STORED,
    statement_descriptor_suffix text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor_suffix'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    transfer_data jsonb GENERATED ALWAYS AS ((_raw_data -> 'transfer_data'::text)) STORED,
    transfer_group text GENERATED ALWAYS AS ((_raw_data ->> 'transfer_group'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.payment_intents OWNER TO postgres;

--
-- Name: payment_methods; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.payment_methods (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    billing_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'billing_details'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    card jsonb GENERATED ALWAYS AS ((_raw_data -> 'card'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.payment_methods OWNER TO postgres;

--
-- Name: payouts; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.payouts (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    date text GENERATED ALWAYS AS ((_raw_data ->> 'date'::text)) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    amount bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::bigint) STORED,
    method text GENERATED ALWAYS AS ((_raw_data ->> 'method'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    automatic boolean GENERATED ALWAYS AS (((_raw_data ->> 'automatic'::text))::boolean) STORED,
    recipient text GENERATED ALWAYS AS ((_raw_data ->> 'recipient'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    destination text GENERATED ALWAYS AS ((_raw_data ->> 'destination'::text)) STORED,
    source_type text GENERATED ALWAYS AS ((_raw_data ->> 'source_type'::text)) STORED,
    arrival_date text GENERATED ALWAYS AS ((_raw_data ->> 'arrival_date'::text)) STORED,
    bank_account jsonb GENERATED ALWAYS AS ((_raw_data -> 'bank_account'::text)) STORED,
    failure_code text GENERATED ALWAYS AS ((_raw_data ->> 'failure_code'::text)) STORED,
    transfer_group text GENERATED ALWAYS AS ((_raw_data ->> 'transfer_group'::text)) STORED,
    amount_reversed bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount_reversed'::text))::bigint) STORED,
    failure_message text GENERATED ALWAYS AS ((_raw_data ->> 'failure_message'::text)) STORED,
    source_transaction text GENERATED ALWAYS AS ((_raw_data ->> 'source_transaction'::text)) STORED,
    balance_transaction text GENERATED ALWAYS AS ((_raw_data ->> 'balance_transaction'::text)) STORED,
    statement_descriptor text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor'::text)) STORED,
    statement_description text GENERATED ALWAYS AS ((_raw_data ->> 'statement_description'::text)) STORED,
    failure_balance_transaction text GENERATED ALWAYS AS ((_raw_data ->> 'failure_balance_transaction'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.payouts OWNER TO postgres;

--
-- Name: plans; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.plans (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    name text GENERATED ALWAYS AS ((_raw_data ->> 'name'::text)) STORED,
    tiers jsonb GENERATED ALWAYS AS ((_raw_data -> 'tiers'::text)) STORED,
    active boolean GENERATED ALWAYS AS (((_raw_data ->> 'active'::text))::boolean) STORED,
    amount bigint GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::bigint) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    product text GENERATED ALWAYS AS ((_raw_data ->> 'product'::text)) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    "interval" text GENERATED ALWAYS AS ((_raw_data ->> 'interval'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    nickname text GENERATED ALWAYS AS ((_raw_data ->> 'nickname'::text)) STORED,
    tiers_mode text GENERATED ALWAYS AS ((_raw_data ->> 'tiers_mode'::text)) STORED,
    usage_type text GENERATED ALWAYS AS ((_raw_data ->> 'usage_type'::text)) STORED,
    billing_scheme text GENERATED ALWAYS AS ((_raw_data ->> 'billing_scheme'::text)) STORED,
    interval_count bigint GENERATED ALWAYS AS (((_raw_data ->> 'interval_count'::text))::bigint) STORED,
    aggregate_usage text GENERATED ALWAYS AS ((_raw_data ->> 'aggregate_usage'::text)) STORED,
    transform_usage text GENERATED ALWAYS AS ((_raw_data ->> 'transform_usage'::text)) STORED,
    trial_period_days bigint GENERATED ALWAYS AS (((_raw_data ->> 'trial_period_days'::text))::bigint) STORED,
    statement_descriptor text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor'::text)) STORED,
    statement_description text GENERATED ALWAYS AS ((_raw_data ->> 'statement_description'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.plans OWNER TO postgres;

--
-- Name: prices; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.prices (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    active boolean GENERATED ALWAYS AS (((_raw_data ->> 'active'::text))::boolean) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    nickname text GENERATED ALWAYS AS ((_raw_data ->> 'nickname'::text)) STORED,
    recurring jsonb GENERATED ALWAYS AS ((_raw_data -> 'recurring'::text)) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    unit_amount integer GENERATED ALWAYS AS (((_raw_data ->> 'unit_amount'::text))::integer) STORED,
    billing_scheme text GENERATED ALWAYS AS ((_raw_data ->> 'billing_scheme'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    lookup_key text GENERATED ALWAYS AS ((_raw_data ->> 'lookup_key'::text)) STORED,
    tiers_mode text GENERATED ALWAYS AS ((_raw_data ->> 'tiers_mode'::text)) STORED,
    transform_quantity jsonb GENERATED ALWAYS AS ((_raw_data -> 'transform_quantity'::text)) STORED,
    unit_amount_decimal text GENERATED ALWAYS AS ((_raw_data ->> 'unit_amount_decimal'::text)) STORED,
    product text GENERATED ALWAYS AS ((_raw_data ->> 'product'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.prices OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.products (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    active boolean GENERATED ALWAYS AS (((_raw_data ->> 'active'::text))::boolean) STORED,
    default_price text GENERATED ALWAYS AS ((_raw_data ->> 'default_price'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    name text GENERATED ALWAYS AS ((_raw_data ->> 'name'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    images jsonb GENERATED ALWAYS AS ((_raw_data -> 'images'::text)) STORED,
    marketing_features jsonb GENERATED ALWAYS AS ((_raw_data -> 'marketing_features'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    package_dimensions jsonb GENERATED ALWAYS AS ((_raw_data -> 'package_dimensions'::text)) STORED,
    shippable boolean GENERATED ALWAYS AS (((_raw_data ->> 'shippable'::text))::boolean) STORED,
    statement_descriptor text GENERATED ALWAYS AS ((_raw_data ->> 'statement_descriptor'::text)) STORED,
    unit_label text GENERATED ALWAYS AS ((_raw_data ->> 'unit_label'::text)) STORED,
    updated integer GENERATED ALWAYS AS (((_raw_data ->> 'updated'::text))::integer) STORED,
    url text GENERATED ALWAYS AS ((_raw_data ->> 'url'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.products OWNER TO postgres;

--
-- Name: refunds; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.refunds (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    amount integer GENERATED ALWAYS AS (((_raw_data ->> 'amount'::text))::integer) STORED,
    balance_transaction text GENERATED ALWAYS AS ((_raw_data ->> 'balance_transaction'::text)) STORED,
    charge text GENERATED ALWAYS AS ((_raw_data ->> 'charge'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    currency text GENERATED ALWAYS AS ((_raw_data ->> 'currency'::text)) STORED,
    destination_details jsonb GENERATED ALWAYS AS ((_raw_data -> 'destination_details'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    reason text GENERATED ALWAYS AS ((_raw_data ->> 'reason'::text)) STORED,
    receipt_number text GENERATED ALWAYS AS ((_raw_data ->> 'receipt_number'::text)) STORED,
    source_transfer_reversal text GENERATED ALWAYS AS ((_raw_data ->> 'source_transfer_reversal'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    transfer_reversal text GENERATED ALWAYS AS ((_raw_data ->> 'transfer_reversal'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.refunds OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.reviews (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    billing_zip text GENERATED ALWAYS AS ((_raw_data ->> 'billing_zip'::text)) STORED,
    charge text GENERATED ALWAYS AS ((_raw_data ->> 'charge'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    closed_reason text GENERATED ALWAYS AS ((_raw_data ->> 'closed_reason'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    ip_address text GENERATED ALWAYS AS ((_raw_data ->> 'ip_address'::text)) STORED,
    ip_address_location jsonb GENERATED ALWAYS AS ((_raw_data -> 'ip_address_location'::text)) STORED,
    open boolean GENERATED ALWAYS AS (((_raw_data ->> 'open'::text))::boolean) STORED,
    opened_reason text GENERATED ALWAYS AS ((_raw_data ->> 'opened_reason'::text)) STORED,
    payment_intent text GENERATED ALWAYS AS ((_raw_data ->> 'payment_intent'::text)) STORED,
    reason text GENERATED ALWAYS AS ((_raw_data ->> 'reason'::text)) STORED,
    session text GENERATED ALWAYS AS ((_raw_data ->> 'session'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.reviews OWNER TO postgres;

--
-- Name: setup_intents; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.setup_intents (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    description text GENERATED ALWAYS AS ((_raw_data ->> 'description'::text)) STORED,
    payment_method text GENERATED ALWAYS AS ((_raw_data ->> 'payment_method'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    usage text GENERATED ALWAYS AS ((_raw_data ->> 'usage'::text)) STORED,
    cancellation_reason text GENERATED ALWAYS AS ((_raw_data ->> 'cancellation_reason'::text)) STORED,
    latest_attempt text GENERATED ALWAYS AS ((_raw_data ->> 'latest_attempt'::text)) STORED,
    mandate text GENERATED ALWAYS AS ((_raw_data ->> 'mandate'::text)) STORED,
    single_use_mandate text GENERATED ALWAYS AS ((_raw_data ->> 'single_use_mandate'::text)) STORED,
    on_behalf_of text GENERATED ALWAYS AS ((_raw_data ->> 'on_behalf_of'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.setup_intents OWNER TO postgres;

--
-- Name: subscription_items; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.subscription_items (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    billing_thresholds jsonb GENERATED ALWAYS AS ((_raw_data -> 'billing_thresholds'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    deleted boolean GENERATED ALWAYS AS (((_raw_data ->> 'deleted'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    quantity integer GENERATED ALWAYS AS (((_raw_data ->> 'quantity'::text))::integer) STORED,
    price text GENERATED ALWAYS AS ((_raw_data ->> 'price'::text)) STORED,
    subscription text GENERATED ALWAYS AS ((_raw_data ->> 'subscription'::text)) STORED,
    tax_rates jsonb GENERATED ALWAYS AS ((_raw_data -> 'tax_rates'::text)) STORED,
    current_period_end integer GENERATED ALWAYS AS (((_raw_data ->> 'current_period_end'::text))::integer) STORED,
    current_period_start integer GENERATED ALWAYS AS (((_raw_data ->> 'current_period_start'::text))::integer) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.subscription_items OWNER TO postgres;

--
-- Name: subscription_schedules; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.subscription_schedules (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    application text GENERATED ALWAYS AS ((_raw_data ->> 'application'::text)) STORED,
    canceled_at integer GENERATED ALWAYS AS (((_raw_data ->> 'canceled_at'::text))::integer) STORED,
    completed_at integer GENERATED ALWAYS AS (((_raw_data ->> 'completed_at'::text))::integer) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    current_phase jsonb GENERATED ALWAYS AS ((_raw_data -> 'current_phase'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    default_settings jsonb GENERATED ALWAYS AS ((_raw_data -> 'default_settings'::text)) STORED,
    end_behavior text GENERATED ALWAYS AS ((_raw_data ->> 'end_behavior'::text)) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    phases jsonb GENERATED ALWAYS AS ((_raw_data -> 'phases'::text)) STORED,
    released_at integer GENERATED ALWAYS AS (((_raw_data ->> 'released_at'::text))::integer) STORED,
    released_subscription text GENERATED ALWAYS AS ((_raw_data ->> 'released_subscription'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    subscription text GENERATED ALWAYS AS ((_raw_data ->> 'subscription'::text)) STORED,
    test_clock text GENERATED ALWAYS AS ((_raw_data ->> 'test_clock'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.subscription_schedules OWNER TO postgres;

--
-- Name: subscriptions; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.subscriptions (
    _updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    cancel_at_period_end boolean GENERATED ALWAYS AS (((_raw_data ->> 'cancel_at_period_end'::text))::boolean) STORED,
    current_period_end integer GENERATED ALWAYS AS (((_raw_data ->> 'current_period_end'::text))::integer) STORED,
    current_period_start integer GENERATED ALWAYS AS (((_raw_data ->> 'current_period_start'::text))::integer) STORED,
    default_payment_method text GENERATED ALWAYS AS ((_raw_data ->> 'default_payment_method'::text)) STORED,
    items jsonb GENERATED ALWAYS AS ((_raw_data -> 'items'::text)) STORED,
    metadata jsonb GENERATED ALWAYS AS ((_raw_data -> 'metadata'::text)) STORED,
    pending_setup_intent text GENERATED ALWAYS AS ((_raw_data ->> 'pending_setup_intent'::text)) STORED,
    pending_update jsonb GENERATED ALWAYS AS ((_raw_data -> 'pending_update'::text)) STORED,
    status text GENERATED ALWAYS AS ((_raw_data ->> 'status'::text)) STORED,
    application_fee_percent double precision GENERATED ALWAYS AS (((_raw_data ->> 'application_fee_percent'::text))::double precision) STORED,
    billing_cycle_anchor integer GENERATED ALWAYS AS (((_raw_data ->> 'billing_cycle_anchor'::text))::integer) STORED,
    billing_thresholds jsonb GENERATED ALWAYS AS ((_raw_data -> 'billing_thresholds'::text)) STORED,
    cancel_at integer GENERATED ALWAYS AS (((_raw_data ->> 'cancel_at'::text))::integer) STORED,
    canceled_at integer GENERATED ALWAYS AS (((_raw_data ->> 'canceled_at'::text))::integer) STORED,
    collection_method text GENERATED ALWAYS AS ((_raw_data ->> 'collection_method'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    days_until_due integer GENERATED ALWAYS AS (((_raw_data ->> 'days_until_due'::text))::integer) STORED,
    default_source text GENERATED ALWAYS AS ((_raw_data ->> 'default_source'::text)) STORED,
    default_tax_rates jsonb GENERATED ALWAYS AS ((_raw_data -> 'default_tax_rates'::text)) STORED,
    discount jsonb GENERATED ALWAYS AS ((_raw_data -> 'discount'::text)) STORED,
    ended_at integer GENERATED ALWAYS AS (((_raw_data ->> 'ended_at'::text))::integer) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    next_pending_invoice_item_invoice integer GENERATED ALWAYS AS (((_raw_data ->> 'next_pending_invoice_item_invoice'::text))::integer) STORED,
    pause_collection jsonb GENERATED ALWAYS AS ((_raw_data -> 'pause_collection'::text)) STORED,
    pending_invoice_item_interval jsonb GENERATED ALWAYS AS ((_raw_data -> 'pending_invoice_item_interval'::text)) STORED,
    start_date integer GENERATED ALWAYS AS (((_raw_data ->> 'start_date'::text))::integer) STORED,
    transfer_data jsonb GENERATED ALWAYS AS ((_raw_data -> 'transfer_data'::text)) STORED,
    trial_end jsonb GENERATED ALWAYS AS ((_raw_data -> 'trial_end'::text)) STORED,
    trial_start jsonb GENERATED ALWAYS AS ((_raw_data -> 'trial_start'::text)) STORED,
    schedule text GENERATED ALWAYS AS ((_raw_data ->> 'schedule'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    latest_invoice text GENERATED ALWAYS AS ((_raw_data ->> 'latest_invoice'::text)) STORED,
    plan text GENERATED ALWAYS AS ((_raw_data ->> 'plan'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.subscriptions OWNER TO postgres;

--
-- Name: tax_ids; Type: TABLE; Schema: stripe; Owner: postgres
--

CREATE TABLE stripe.tax_ids (
    _last_synced_at timestamp with time zone,
    _raw_data jsonb,
    _account_id text NOT NULL,
    object text GENERATED ALWAYS AS ((_raw_data ->> 'object'::text)) STORED,
    country text GENERATED ALWAYS AS ((_raw_data ->> 'country'::text)) STORED,
    customer text GENERATED ALWAYS AS ((_raw_data ->> 'customer'::text)) STORED,
    type text GENERATED ALWAYS AS ((_raw_data ->> 'type'::text)) STORED,
    value text GENERATED ALWAYS AS ((_raw_data ->> 'value'::text)) STORED,
    created integer GENERATED ALWAYS AS (((_raw_data ->> 'created'::text))::integer) STORED,
    livemode boolean GENERATED ALWAYS AS (((_raw_data ->> 'livemode'::text))::boolean) STORED,
    owner jsonb GENERATED ALWAYS AS ((_raw_data -> 'owner'::text)) STORED,
    id text GENERATED ALWAYS AS ((_raw_data ->> 'id'::text)) STORED NOT NULL
);


ALTER TABLE stripe.tax_ids OWNER TO postgres;

--
-- Name: paid_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paid_orders ALTER COLUMN id SET DEFAULT nextval('public.paid_orders_id_seq'::regclass);


--
-- Name: trial_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trial_tokens ALTER COLUMN id SET DEFAULT nextval('public.trial_tokens_id_seq'::regclass);


--
-- Name: trial_tokens access_count; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trial_tokens ALTER COLUMN access_count SET DEFAULT nextval('public.trial_tokens_access_count_seq'::regclass);


--
-- Name: _sync_status id; Type: DEFAULT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._sync_status ALTER COLUMN id SET DEFAULT nextval('stripe._sync_status_id_seq'::regclass);


--
-- Data for Name: customer_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_tokens (token, plan_type, used, created_at, used_at) FROM stdin;
intermediate_8l5s0p98	1:45	f	2026-01-22 21:50:51.342171	\N
beginner_dx3ohmg6	2:00	f	2026-01-23 07:48:21.34378	\N
beginner_6ip3jmld	2:00	f	2026-01-23 07:48:33.213217	\N
beginner_5eogz42e	2:00	f	2026-01-23 07:48:48.80349	\N
beginner_3oa1b17u	2:00	f	2026-01-23 07:48:49.523719	\N
intermediate_pbvxkzq5	1:45	f	2026-01-23 19:18:54.699258	\N
intermediate_65754g8u	1:45	f	2026-01-23 19:19:15.985811	\N
beginner_lrmoyvd4	2:00	f	2026-01-24 07:46:45.197893	\N
beginner_n8rtshoh	2:00	f	2026-01-24 08:24:00.335319	\N
beginner_bc96p67b	2:00	f	2026-01-24 19:38:16.525572	\N
beginner_11ipt0cd	2:00	f	2026-01-24 19:51:04.094654	\N
intermediate_65tm8o3k	1:45	f	2026-01-24 19:51:06.868889	\N
beginner_m5crv0l6	2:00	f	2026-01-30 12:57:29.063028	\N
beginner_o0j8cws7	2:00	f	2026-01-30 13:41:30.416984	\N
beginner_wkp2ua2s	2:00	f	2026-01-30 13:43:20.455006	\N
beginner_m6no4rnv	2:00	f	2026-01-30 13:48:38.571011	\N
beginner_i1jargqp	2:00	f	2026-01-30 22:28:03.545413	\N
beginner_pxt71sdh	2:00	f	2026-01-30 22:28:31.964506	\N
beginner_5b6fv4ti	2:00	f	2026-01-30 22:30:02.507062	\N
beginner_7ntnsu4l	2:00	f	2026-01-30 22:31:34.3245	\N
beginner_0zc79vuk	2:00	f	2026-01-30 22:32:29.653659	\N
intermediate_cyxjbtd8	1:45	f	2026-02-01 18:13:40.095547	\N
beginner_7qn2wtao	2:00	t	2026-02-05 22:15:22.843502	2026-02-05 22:15:34.587
beginner_qrv8brzi	2:00	t	2026-02-05 22:19:42.247336	2026-02-05 22:19:55.172
beginner_nrzzkkjf	2:00	f	2026-02-05 22:26:19.585049	\N
beginner_ma5kai5v	2:00	t	2026-02-05 22:24:14.62927	2026-02-05 22:26:28.114
beginner_9qht1dmj	2:00	t	2026-02-05 22:43:41.010746	2026-02-05 22:43:57.757
beginner_bhoyc5qu	2:00	f	2026-02-05 22:53:08.286881	\N
beginner_7l2u9rav	2:00	f	2026-02-05 23:01:20.073885	\N
beginner_0m9noy5q	2:00	f	2026-02-05 23:04:54.23627	\N
beginner_00towtwv	2:00	t	2026-02-17 19:06:27.490706	2026-02-17 21:26:41.132
beginner_phm1vgkn	2:00	t	2026-02-17 21:33:08.115017	2026-02-17 21:33:17.25
\.


--
-- Data for Name: paid_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paid_orders (id, email, stripe_session_id, token, plan_type, created_at) FROM stdin;
1	test@test.com	cs_test_a1mk4hwoPKyv3yt3Ft7cYPw6Kg9a62DZKKdx3Rpj6PctVPyoffU8JOg7S2	beginner_00towtwv	2:00	2026-02-17 19:06:27.495496
\.


--
-- Data for Name: trial_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trial_tokens (id, email, name, plan_type, gender, age, experience, weekly_distance, current_pace, longest_run, goal, created_at, expires_at, access_count) FROM stdin;
1	test@example.com	Test User	1:45	Male	30	1–2 years	20–40 km	4:30–5:30 / km	15 km	~1:45 hours	2026-02-17 17:28:58.152786	2026-02-24 17:28:58.129	1
2	test@test.com	Test User	2:00	\N	\N	beginner	10-20 km	6:00-6:30/km	10 km	2:00 hours	2026-02-17 18:54:18.71212	2026-02-24 18:54:18.71212	9
\.


--
-- Data for Name: _managed_webhooks; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe._managed_webhooks (id, object, url, enabled_events, description, enabled, livemode, metadata, secret, status, api_version, created, updated_at, last_synced_at, account_id) FROM stdin;
we_1T1slXKBWxKSrpz5PkLCL19b	webhook_endpoint	https://52c1d740-c6df-4017-b256-7b91c8319238-00-2zee7755plo16.kirk.replit.dev/api/stripe/webhook	["charge.captured", "charge.dispute.closed", "charge.dispute.created", "charge.dispute.funds_reinstated", "charge.dispute.funds_withdrawn", "charge.dispute.updated", "charge.expired", "charge.failed", "charge.pending", "charge.refund.updated", "charge.refunded", "charge.succeeded", "charge.updated", "checkout.session.async_payment_failed", "checkout.session.async_payment_succeeded", "checkout.session.completed", "checkout.session.expired", "credit_note.created", "credit_note.updated", "credit_note.voided", "customer.created", "customer.deleted", "customer.subscription.created", "customer.subscription.deleted", "customer.subscription.paused", "customer.subscription.pending_update_applied", "customer.subscription.pending_update_expired", "customer.subscription.resumed", "customer.subscription.trial_will_end", "customer.subscription.updated", "customer.tax_id.created", "customer.tax_id.deleted", "customer.tax_id.updated", "customer.updated", "entitlements.active_entitlement_summary.updated", "invoice.created", "invoice.deleted", "invoice.finalization_failed", "invoice.finalized", "invoice.marked_uncollectible", "invoice.paid", "invoice.payment_action_required", "invoice.payment_failed", "invoice.payment_succeeded", "invoice.sent", "invoice.upcoming", "invoice.updated", "invoice.voided", "payment_intent.amount_capturable_updated", "payment_intent.canceled", "payment_intent.created", "payment_intent.partially_funded", "payment_intent.payment_failed", "payment_intent.processing", "payment_intent.requires_action", "payment_intent.succeeded", "payment_method.attached", "payment_method.automatically_updated", "payment_method.card_automatically_updated", "payment_method.detached", "payment_method.updated", "plan.created", "plan.deleted", "plan.updated", "price.created", "price.deleted", "price.updated", "product.created", "product.deleted", "product.updated", "radar.early_fraud_warning.created", "radar.early_fraud_warning.updated", "refund.created", "refund.failed", "refund.updated", "review.closed", "review.opened", "setup_intent.canceled", "setup_intent.created", "setup_intent.requires_action", "setup_intent.setup_failed", "setup_intent.succeeded", "subscription_schedule.aborted", "subscription_schedule.canceled", "subscription_schedule.completed", "subscription_schedule.created", "subscription_schedule.expiring", "subscription_schedule.released", "subscription_schedule.updated"]	\N	\N	f	{"managed_by": "stripe-sync"}	whsec_cMDtzZSFmqKKBdNKjBAEF8YY8IjuLOLZ	enabled	\N	1771351975	2026-02-17 18:12:55.762182+00	2026-02-17 18:12:55.76+00	acct_1T1sJZKBWxKSrpz5
\.


--
-- Data for Name: _migrations; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe._migrations (id, name, hash, executed_at) FROM stdin;
0	initial_migration	c18983eedaa79cc2f6d92727d70c4f772256ef3d	2026-02-17 18:12:46.727394
1	products	b99ffc23df668166b94156f438bfa41818d4e80c	2026-02-17 18:12:46.733891
2	customers	33e481247ddc217f4e27ad10dfe5430097981670	2026-02-17 18:12:46.745732
3	prices	7d5ff35640651606cc24cec8a73ff7c02492ecdf	2026-02-17 18:12:46.756865
4	subscriptions	2cc6121a943c2a623c604e5ab12118a57a6c329a	2026-02-17 18:12:46.78067
5	invoices	7fbb4ccb4ed76a830552520739aaa163559771b1	2026-02-17 18:12:46.792333
6	charges	fb284ed969f033f5ce19f479b7a7e27871bddf09	2026-02-17 18:12:46.8059
7	coupons	7ed6ec4133f120675fd7888c0477b6281743fede	2026-02-17 18:12:46.815437
8	disputes	29bdb083725efe84252647f043f5f91cd0dabf43	2026-02-17 18:12:46.824574
9	events	b28cb55b5b69a9f52ef519260210cd76eea3c84e	2026-02-17 18:12:46.83338
10	payouts	69d1050b88bba1024cea4a671f9633ce7bfe25ff	2026-02-17 18:12:46.841149
11	plans	fc1ae945e86d1222a59cbcd3ae7e81a3a282a60c	2026-02-17 18:12:46.849322
12	add_updated_at	1d80945ef050a17a26e35e9983a58178262470f2	2026-02-17 18:12:46.857362
13	add_subscription_items	2aa63409bfe910add833155ad7468cdab844e0f1	2026-02-17 18:12:46.870679
14	migrate_subscription_items	8c2a798b44a8a0d83ede6f50ea7113064ecc1807	2026-02-17 18:12:46.87959
15	add_customer_deleted	6886ddfd8c129d3c4b39b59519f92618b397b395	2026-02-17 18:12:46.885169
16	add_invoice_indexes	d6bb9a09d5bdf580986ed14f55db71227a4d356d	2026-02-17 18:12:46.888028
17	drop_charges_unavailable_columns	61cd5adec4ae2c308d2c33d1b0ed203c7d074d6a	2026-02-17 18:12:46.894861
18	setup_intents	1d45d0fa47fc145f636c9e3c1ea692417fbb870d	2026-02-17 18:12:46.898395
19	payment_methods	705bdb15b50f1a97260b4f243008b8a34d23fb09	2026-02-17 18:12:46.909107
20	disputes_payment_intent_created_idx	18b2cecd7c097a7ea3b3f125f228e8790288d5ca	2026-02-17 18:12:46.919607
21	payment_intent	b1f194ff521b373c4c7cf220c0feadc253ebff0b	2026-02-17 18:12:46.923788
22	adjust_plans	e4eae536b0bc98ee14d78e818003952636ee877c	2026-02-17 18:12:46.935531
23	invoice_deleted	78e864c3146174fee7d08f05226b02d931d5b2ae	2026-02-17 18:12:46.938353
24	subscription_schedules	85fa6adb3815619bb17e1dafb00956ff548f7332	2026-02-17 18:12:46.94163
25	tax_ids	3f9a1163533f9e60a53d61dae5e451ab937584d9	2026-02-17 18:12:46.948936
26	credit_notes	e099b6b04ee607ee868d82af5193373c3fc266d2	2026-02-17 18:12:46.960125
27	add_marketing_features_to_products	6ed1774b0a9606c5937b2385d61057408193e8a7	2026-02-17 18:12:46.972033
28	early_fraud_warning	e615b0b73fa13d3b0508a1956d496d516f0ebf40	2026-02-17 18:12:46.975634
29	reviews	dd3f914139725a7934dc1062de4cc05aece77aea	2026-02-17 18:12:46.986795
30	refunds	f76c4e273eccdc96616424d73967a9bea3baac4e	2026-02-17 18:12:46.999026
31	add_default_price	6d10566a68bc632831fa25332727d8ff842caec5	2026-02-17 18:12:47.011314
32	update_subscription_items	e894858d46840ba4be5ea093cdc150728bd1d66f	2026-02-17 18:12:47.014146
33	add_last_synced_at	43124eb65b18b70c54d57d2b4fcd5dae718a200f	2026-02-17 18:12:47.01702
34	remove_foreign_keys	e72ec19f3232cf6e6b7308ebab80341c2341745f	2026-02-17 18:12:47.020776
35	checkout_sessions	dc294f5bb1a4d613be695160b38a714986800a75	2026-02-17 18:12:47.02433
36	checkout_session_line_items	82c8cfce86d68db63a9fa8de973bfe60c91342dd	2026-02-17 18:12:47.042306
37	add_features	c68a2c2b7e3808eed28c8828b2ffd3a2c9bf2bd4	2026-02-17 18:12:47.061054
38	active_entitlement	5b3858e7a52212b01e7f338cf08e29767ab362af	2026-02-17 18:12:47.072957
39	add_paused_to_subscription_status	09012b5d128f6ba25b0c8f69a1203546cf1c9f10	2026-02-17 18:12:47.088888
40	managed_webhooks	1d453dfd0e27ff0c2de97955c4ec03919af0af7f	2026-02-17 18:12:47.092865
41	rename_managed_webhooks	ad7cd1e4971a50790bf997cd157f3403d294484f	2026-02-17 18:12:47.111618
42	convert_to_jsonb_generated_columns	e0703a0e5cd9d97db53d773ada1983553e37813c	2026-02-17 18:12:47.114808
43	add_account_id	9a6beffdd0972e3657b7118b2c5001be1f815faf	2026-02-17 18:12:50.465204
44	make_account_id_required	05c1e9145220e905e0c1ca5329851acaf7e9e506	2026-02-17 18:12:50.477339
45	sync_status	2f88c4883fa885a6eaa23b8b02da958ca77a1c21	2026-02-17 18:12:50.493034
46	sync_status_per_account	b1f1f3d4fdb4b4cf4e489d4b195c7f0f97f9f27c	2026-02-17 18:12:50.504276
47	api_key_hashes	8046e4c57544b8eae277b057d201a28a4529ffe3	2026-02-17 18:12:50.537225
48	rename_reserved_columns	e32290f655550ed308a7f2dcb5b0114e49a0558e	2026-02-17 18:12:50.541161
49	remove_redundant_underscores_from_metadata_tables	96d6f3a54e17d8e19abd022a030a95a6161bf73e	2026-02-17 18:12:54.524307
50	rename_id_to_match_stripe_api	c5300c5a10081c033dab9961f4e3cd6a2440c2b6	2026-02-17 18:12:54.536929
51	remove_webhook_uuid	289bee08167858dbf4d04ca184f42681660ebb66	2026-02-17 18:12:54.858247
52	webhook_url_uniqueness	d02aec1815ce3a108b8a1def1ff24e865b26db70	2026-02-17 18:12:54.863005
\.


--
-- Data for Name: _sync_status; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe._sync_status (id, resource, status, last_synced_at, last_incremental_cursor, error_message, updated_at, account_id) FROM stdin;
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.accounts (_raw_data, first_synced_at, _last_synced_at, _updated_at, api_key_hashes) FROM stdin;
{"id": "acct_1T1sJZKBWxKSrpz5", "type": "standard", "email": null, "object": "account", "country": "US", "settings": {"payouts": {"schedule": {"interval": "daily", "delay_days": 2}, "statement_descriptor": null, "debit_negative_balances": true}, "branding": {"icon": null, "logo": null, "primary_color": null, "secondary_color": null}, "invoices": {"default_account_tax_ids": null, "hosted_payment_method_save": "offer"}, "payments": {"statement_descriptor": null, "statement_descriptor_kana": null, "statement_descriptor_kanji": null}, "dashboard": {"timezone": "Etc/UTC", "display_name": "EasyHalf Sandbox"}, "card_issuing": {"tos_acceptance": {"ip": null, "date": null}}, "card_payments": {"statement_descriptor_prefix": null, "statement_descriptor_prefix_kana": null, "statement_descriptor_prefix_kanji": null}, "bacs_debit_payments": {"display_name": null, "service_user_number": null}, "sepa_debit_payments": {}}, "controller": {"type": "account"}, "capabilities": {}, "business_type": null, "charges_enabled": false, "payouts_enabled": false, "business_profile": {"mcc": null, "url": null, "name": null, "support_url": null, "support_email": null, "support_phone": null, "annual_revenue": null, "support_address": null, "estimated_worker_count": null, "minority_owned_business_designation": null}, "default_currency": "usd", "details_submitted": false}	2026-02-17 18:12:55.456141+00	2026-02-17 18:12:55.456141+00	2026-02-17 18:12:55.456141+00	{ac573db1c638e9e8d3bd30e3148a9b473c20be9edb02e228e8c364b7de7d7d16}
\.


--
-- Data for Name: active_entitlements; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.active_entitlements (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: charges; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.charges (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: checkout_session_line_items; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.checkout_session_line_items (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
2026-02-17 19:06:27.424351+00	2026-02-17 19:06:26+00	{"id": "li_1T1tbCKBWxKSrpz5NlFyQU1d", "price": "price_1T1tXQKBWxKSrpz5M31zmNRC", "object": "item", "currency": "usd", "metadata": {}, "quantity": 1, "amount_tax": 0, "description": "HM training plan - test", "amount_total": 0, "amount_discount": 0, "amount_subtotal": 0, "checkout_session": "cs_test_a1mk4hwoPKyv3yt3Ft7cYPw6Kg9a62DZKKdx3Rpj6PctVPyoffU8JOg7S2", "adjustable_quantity": null}	acct_1T1sJZKBWxKSrpz5
\.


--
-- Data for Name: checkout_sessions; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.checkout_sessions (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
2026-02-17 19:06:26.854144+00	2026-02-17 19:06:26+00	{"id": "cs_test_a1mk4hwoPKyv3yt3Ft7cYPw6Kg9a62DZKKdx3Rpj6PctVPyoffU8JOg7S2", "url": null, "mode": "payment", "locale": "auto", "object": "checkout.session", "status": "complete", "consent": null, "created": 1771355178, "invoice": null, "ui_mode": "hosted", "currency": "usd", "customer": null, "livemode": false, "metadata": {}, "discounts": [], "cancel_url": "https://stripe.com", "expires_at": 1771441578, "custom_text": {"submit": null, "after_submit": null, "shipping_address": null, "terms_of_service_acceptance": null}, "permissions": null, "submit_type": "auto", "success_url": "https://easyhalf.replit.app/payment-success?session_id={CHECKOUT_SESSION_ID}", "amount_total": 0, "payment_link": "plink_1T1tYWKBWxKSrpz5wfxirqzx", "setup_intent": null, "subscription": null, "automatic_tax": {"status": null, "enabled": false, "provider": null, "liability": null}, "client_secret": null, "custom_fields": [], "shipping_cost": null, "total_details": {"amount_tax": 0, "amount_discount": 0, "amount_shipping": 0}, "customer_email": null, "origin_context": null, "payment_intent": null, "payment_status": "paid", "recovered_from": null, "wallet_options": null, "amount_subtotal": 0, "adaptive_pricing": {"enabled": true}, "after_expiration": null, "customer_account": null, "customer_details": {"name": null, "email": "test@test.com", "phone": null, "address": null, "tax_ids": [], "tax_exempt": "none", "business_name": null, "individual_name": null}, "invoice_creation": {"enabled": false, "invoice_data": {"footer": null, "issuer": null, "metadata": {}, "description": null, "custom_fields": null, "account_tax_ids": null, "rendering_options": null}}, "shipping_options": [], "customer_creation": "if_required", "consent_collection": {"promotions": "none", "terms_of_service": "none", "payment_method_reuse_agreement": null}, "client_reference_id": null, "currency_conversion": null, "presentment_details": {"presentment_amount": 0, "presentment_currency": "czk"}, "payment_method_types": ["card", "link"], "allow_promotion_codes": false, "collected_information": null, "payment_method_options": {"card": {"request_three_d_secure": "automatic"}}, "phone_number_collection": {"enabled": false}, "payment_method_collection": "if_required", "billing_address_collection": "auto", "shipping_address_collection": null, "saved_payment_method_options": null, "payment_method_configuration_details": null}	acct_1T1sJZKBWxKSrpz5
\.


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.coupons (_updated_at, _last_synced_at, _raw_data) FROM stdin;
\.


--
-- Data for Name: credit_notes; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.credit_notes (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.customers (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: disputes; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.disputes (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: early_fraud_warnings; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.early_fraud_warnings (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.events (_updated_at, _last_synced_at, _raw_data) FROM stdin;
\.


--
-- Data for Name: features; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.features (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.invoices (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: payment_intents; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.payment_intents (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.payment_methods (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: payouts; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.payouts (_updated_at, _last_synced_at, _raw_data) FROM stdin;
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.plans (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: prices; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.prices (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
2026-02-17 19:02:24.459934+00	2026-02-17 19:02:24+00	{"id": "price_1T1tXQKBWxKSrpz5M31zmNRC", "type": "one_time", "active": true, "object": "price", "created": 1771354944, "product": "prod_TztKJDLztr0oTR", "currency": "usd", "livemode": false, "metadata": {}, "nickname": null, "recurring": null, "lookup_key": null, "tiers_mode": null, "unit_amount": 0, "tax_behavior": "exclusive", "billing_scheme": "per_unit", "custom_unit_amount": null, "transform_quantity": null, "unit_amount_decimal": "0"}	acct_1T1sJZKBWxKSrpz5
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.products (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
2026-02-17 19:02:24.978543+00	2026-02-17 19:02:24+00	{"id": "prod_TztKJDLztr0oTR", "url": null, "name": "HM training plan - test", "type": "service", "active": true, "images": [], "object": "product", "created": 1771354943, "updated": 1771354944, "livemode": false, "metadata": {}, "tax_code": "txcd_20060058", "shippable": null, "attributes": [], "unit_label": null, "description": null, "default_price": "price_1T1tXQKBWxKSrpz5M31zmNRC", "marketing_features": [], "package_dimensions": null, "statement_descriptor": null}	acct_1T1sJZKBWxKSrpz5
\.


--
-- Data for Name: refunds; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.refunds (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.reviews (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: setup_intents; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.setup_intents (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: subscription_items; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.subscription_items (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: subscription_schedules; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.subscription_schedules (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.subscriptions (_updated_at, _last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Data for Name: tax_ids; Type: TABLE DATA; Schema: stripe; Owner: postgres
--

COPY stripe.tax_ids (_last_synced_at, _raw_data, _account_id) FROM stdin;
\.


--
-- Name: paid_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paid_orders_id_seq', 1, true);


--
-- Name: trial_tokens_access_count_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trial_tokens_access_count_seq', 1, true);


--
-- Name: trial_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trial_tokens_id_seq', 2, true);


--
-- Name: _sync_status_id_seq; Type: SEQUENCE SET; Schema: stripe; Owner: postgres
--

SELECT pg_catalog.setval('stripe._sync_status_id_seq', 1, false);


--
-- Name: customer_tokens customer_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_tokens
    ADD CONSTRAINT customer_tokens_pkey PRIMARY KEY (token);


--
-- Name: paid_orders paid_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paid_orders
    ADD CONSTRAINT paid_orders_pkey PRIMARY KEY (id);


--
-- Name: trial_tokens trial_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trial_tokens
    ADD CONSTRAINT trial_tokens_pkey PRIMARY KEY (id);


--
-- Name: _migrations _migrations_name_key; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._migrations
    ADD CONSTRAINT _migrations_name_key UNIQUE (name);


--
-- Name: _migrations _migrations_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._migrations
    ADD CONSTRAINT _migrations_pkey PRIMARY KEY (id);


--
-- Name: _sync_status _sync_status_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._sync_status
    ADD CONSTRAINT _sync_status_pkey PRIMARY KEY (id);


--
-- Name: _sync_status _sync_status_resource_account_key; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._sync_status
    ADD CONSTRAINT _sync_status_resource_account_key UNIQUE (resource, account_id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: active_entitlements active_entitlements_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.active_entitlements
    ADD CONSTRAINT active_entitlements_pkey PRIMARY KEY (id);


--
-- Name: charges charges_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.charges
    ADD CONSTRAINT charges_pkey PRIMARY KEY (id);


--
-- Name: checkout_session_line_items checkout_session_line_items_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.checkout_session_line_items
    ADD CONSTRAINT checkout_session_line_items_pkey PRIMARY KEY (id);


--
-- Name: checkout_sessions checkout_sessions_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.checkout_sessions
    ADD CONSTRAINT checkout_sessions_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: credit_notes credit_notes_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.credit_notes
    ADD CONSTRAINT credit_notes_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: disputes disputes_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.disputes
    ADD CONSTRAINT disputes_pkey PRIMARY KEY (id);


--
-- Name: early_fraud_warnings early_fraud_warnings_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.early_fraud_warnings
    ADD CONSTRAINT early_fraud_warnings_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: features features_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.features
    ADD CONSTRAINT features_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: _managed_webhooks managed_webhooks_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._managed_webhooks
    ADD CONSTRAINT managed_webhooks_pkey PRIMARY KEY (id);


--
-- Name: _managed_webhooks managed_webhooks_url_account_unique; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._managed_webhooks
    ADD CONSTRAINT managed_webhooks_url_account_unique UNIQUE (url, account_id);


--
-- Name: payment_intents payment_intents_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.payment_intents
    ADD CONSTRAINT payment_intents_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payouts payouts_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.payouts
    ADD CONSTRAINT payouts_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: prices prices_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: refunds refunds_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.refunds
    ADD CONSTRAINT refunds_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: setup_intents setup_intents_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.setup_intents
    ADD CONSTRAINT setup_intents_pkey PRIMARY KEY (id);


--
-- Name: subscription_items subscription_items_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.subscription_items
    ADD CONSTRAINT subscription_items_pkey PRIMARY KEY (id);


--
-- Name: subscription_schedules subscription_schedules_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.subscription_schedules
    ADD CONSTRAINT subscription_schedules_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: tax_ids tax_ids_pkey; Type: CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.tax_ids
    ADD CONSTRAINT tax_ids_pkey PRIMARY KEY (id);


--
-- Name: active_entitlements_lookup_key_key; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE UNIQUE INDEX active_entitlements_lookup_key_key ON stripe.active_entitlements USING btree (lookup_key) WHERE (lookup_key IS NOT NULL);


--
-- Name: features_lookup_key_key; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE UNIQUE INDEX features_lookup_key_key ON stripe.features USING btree (lookup_key) WHERE (lookup_key IS NOT NULL);


--
-- Name: idx_accounts_api_key_hashes; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX idx_accounts_api_key_hashes ON stripe.accounts USING gin (api_key_hashes);


--
-- Name: idx_accounts_business_name; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX idx_accounts_business_name ON stripe.accounts USING btree (business_name);


--
-- Name: idx_sync_status_resource_account; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX idx_sync_status_resource_account ON stripe._sync_status USING btree (resource, account_id);


--
-- Name: stripe_active_entitlements_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_active_entitlements_customer_idx ON stripe.active_entitlements USING btree (customer);


--
-- Name: stripe_active_entitlements_feature_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_active_entitlements_feature_idx ON stripe.active_entitlements USING btree (feature);


--
-- Name: stripe_checkout_session_line_items_price_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_checkout_session_line_items_price_idx ON stripe.checkout_session_line_items USING btree (price);


--
-- Name: stripe_checkout_session_line_items_session_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_checkout_session_line_items_session_idx ON stripe.checkout_session_line_items USING btree (checkout_session);


--
-- Name: stripe_checkout_sessions_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_checkout_sessions_customer_idx ON stripe.checkout_sessions USING btree (customer);


--
-- Name: stripe_checkout_sessions_invoice_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_checkout_sessions_invoice_idx ON stripe.checkout_sessions USING btree (invoice);


--
-- Name: stripe_checkout_sessions_payment_intent_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_checkout_sessions_payment_intent_idx ON stripe.checkout_sessions USING btree (payment_intent);


--
-- Name: stripe_checkout_sessions_subscription_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_checkout_sessions_subscription_idx ON stripe.checkout_sessions USING btree (subscription);


--
-- Name: stripe_credit_notes_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_credit_notes_customer_idx ON stripe.credit_notes USING btree (customer);


--
-- Name: stripe_credit_notes_invoice_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_credit_notes_invoice_idx ON stripe.credit_notes USING btree (invoice);


--
-- Name: stripe_dispute_created_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_dispute_created_idx ON stripe.disputes USING btree (created);


--
-- Name: stripe_early_fraud_warnings_charge_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_early_fraud_warnings_charge_idx ON stripe.early_fraud_warnings USING btree (charge);


--
-- Name: stripe_early_fraud_warnings_payment_intent_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_early_fraud_warnings_payment_intent_idx ON stripe.early_fraud_warnings USING btree (payment_intent);


--
-- Name: stripe_invoices_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_invoices_customer_idx ON stripe.invoices USING btree (customer);


--
-- Name: stripe_invoices_subscription_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_invoices_subscription_idx ON stripe.invoices USING btree (subscription);


--
-- Name: stripe_managed_webhooks_enabled_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_managed_webhooks_enabled_idx ON stripe._managed_webhooks USING btree (enabled);


--
-- Name: stripe_managed_webhooks_status_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_managed_webhooks_status_idx ON stripe._managed_webhooks USING btree (status);


--
-- Name: stripe_payment_intents_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_payment_intents_customer_idx ON stripe.payment_intents USING btree (customer);


--
-- Name: stripe_payment_intents_invoice_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_payment_intents_invoice_idx ON stripe.payment_intents USING btree (invoice);


--
-- Name: stripe_payment_methods_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_payment_methods_customer_idx ON stripe.payment_methods USING btree (customer);


--
-- Name: stripe_refunds_charge_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_refunds_charge_idx ON stripe.refunds USING btree (charge);


--
-- Name: stripe_refunds_payment_intent_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_refunds_payment_intent_idx ON stripe.refunds USING btree (payment_intent);


--
-- Name: stripe_reviews_charge_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_reviews_charge_idx ON stripe.reviews USING btree (charge);


--
-- Name: stripe_reviews_payment_intent_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_reviews_payment_intent_idx ON stripe.reviews USING btree (payment_intent);


--
-- Name: stripe_setup_intents_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_setup_intents_customer_idx ON stripe.setup_intents USING btree (customer);


--
-- Name: stripe_tax_ids_customer_idx; Type: INDEX; Schema: stripe; Owner: postgres
--

CREATE INDEX stripe_tax_ids_customer_idx ON stripe.tax_ids USING btree (customer);


--
-- Name: _managed_webhooks handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe._managed_webhooks FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_metadata();


--
-- Name: _sync_status handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe._sync_status FOR EACH ROW EXECUTE FUNCTION public.set_updated_at_metadata();


--
-- Name: accounts handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.accounts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: active_entitlements handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.active_entitlements FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: charges handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.charges FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: checkout_session_line_items handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.checkout_session_line_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: checkout_sessions handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.checkout_sessions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: coupons handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.coupons FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: customers handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.customers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: disputes handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.disputes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: early_fraud_warnings handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.early_fraud_warnings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: events handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.events FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: features handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.features FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: invoices handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.invoices FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: payouts handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.payouts FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: plans handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.plans FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: prices handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.prices FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: products handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: refunds handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.refunds FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: reviews handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.reviews FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: subscriptions handle_updated_at; Type: TRIGGER; Schema: stripe; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON stripe.subscriptions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: active_entitlements fk_active_entitlements_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.active_entitlements
    ADD CONSTRAINT fk_active_entitlements_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: charges fk_charges_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.charges
    ADD CONSTRAINT fk_charges_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: checkout_session_line_items fk_checkout_session_line_items_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.checkout_session_line_items
    ADD CONSTRAINT fk_checkout_session_line_items_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: checkout_sessions fk_checkout_sessions_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.checkout_sessions
    ADD CONSTRAINT fk_checkout_sessions_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: credit_notes fk_credit_notes_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.credit_notes
    ADD CONSTRAINT fk_credit_notes_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: customers fk_customers_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.customers
    ADD CONSTRAINT fk_customers_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: disputes fk_disputes_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.disputes
    ADD CONSTRAINT fk_disputes_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: early_fraud_warnings fk_early_fraud_warnings_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.early_fraud_warnings
    ADD CONSTRAINT fk_early_fraud_warnings_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: features fk_features_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.features
    ADD CONSTRAINT fk_features_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: invoices fk_invoices_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.invoices
    ADD CONSTRAINT fk_invoices_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: _managed_webhooks fk_managed_webhooks_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._managed_webhooks
    ADD CONSTRAINT fk_managed_webhooks_account FOREIGN KEY (account_id) REFERENCES stripe.accounts(id);


--
-- Name: payment_intents fk_payment_intents_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.payment_intents
    ADD CONSTRAINT fk_payment_intents_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: payment_methods fk_payment_methods_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.payment_methods
    ADD CONSTRAINT fk_payment_methods_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: plans fk_plans_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.plans
    ADD CONSTRAINT fk_plans_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: prices fk_prices_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.prices
    ADD CONSTRAINT fk_prices_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: products fk_products_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.products
    ADD CONSTRAINT fk_products_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: refunds fk_refunds_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.refunds
    ADD CONSTRAINT fk_refunds_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: reviews fk_reviews_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.reviews
    ADD CONSTRAINT fk_reviews_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: setup_intents fk_setup_intents_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.setup_intents
    ADD CONSTRAINT fk_setup_intents_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: subscription_items fk_subscription_items_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.subscription_items
    ADD CONSTRAINT fk_subscription_items_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: subscription_schedules fk_subscription_schedules_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.subscription_schedules
    ADD CONSTRAINT fk_subscription_schedules_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: subscriptions fk_subscriptions_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.subscriptions
    ADD CONSTRAINT fk_subscriptions_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- Name: _sync_status fk_sync_status_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe._sync_status
    ADD CONSTRAINT fk_sync_status_account FOREIGN KEY (account_id) REFERENCES stripe.accounts(id);


--
-- Name: tax_ids fk_tax_ids_account; Type: FK CONSTRAINT; Schema: stripe; Owner: postgres
--

ALTER TABLE ONLY stripe.tax_ids
    ADD CONSTRAINT fk_tax_ids_account FOREIGN KEY (_account_id) REFERENCES stripe.accounts(id);


--
-- PostgreSQL database dump complete
--

\unrestrict vuQBA0PjIROGQkYChgb0h1KkUUhpcYJlBMGucZgi4Adt4dI7zCfwEBtezKyGdQ4

