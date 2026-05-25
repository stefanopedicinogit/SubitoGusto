


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


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."get_my_restaurant_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
    SELECT tenant_id FROM users WHERE id = auth.uid()
  $$;


ALTER FUNCTION "public"."get_my_restaurant_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_my_tenant_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
    SELECT tenant_id FROM public.users WHERE id = auth.uid()
  $$;


ALTER FUNCTION "public"."get_my_tenant_id"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."tables" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "qr_code" "text" NOT NULL,
    "capacity" integer DEFAULT 4,
    "zone" "text",
    "status" "text" DEFAULT 'available'::"text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    CONSTRAINT "tables_status_check" CHECK (("status" = ANY (ARRAY['available'::"text", 'occupied'::"text", 'reserved'::"text"])))
);


ALTER TABLE "public"."tables" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_table_by_qr"("qr" "text") RETURNS SETOF "public"."tables"
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
    SELECT * FROM tables WHERE qr_code = qr AND is_active = true LIMIT 1;
  $$;


ALTER FUNCTION "public"."get_table_by_qr"("qr" "text") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "image_url" "text",
    "sort_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."categories" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_tenant_categories"("tid" "uuid") RETURNS SETOF "public"."categories"
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
    SELECT * FROM categories
    WHERE tenant_id = tid AND is_active = true
    ORDER BY sort_order;
  $$;


ALTER FUNCTION "public"."get_tenant_categories"("tid" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fixed_menus" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "image_url" "text",
    "price" numeric(10,2) NOT NULL,
    "available_for" "text" DEFAULT 'all'::"text",
    "available_days" "text"[],
    "valid_from" timestamp with time zone,
    "valid_to" timestamp with time zone,
    "sort_order" integer DEFAULT 0,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    CONSTRAINT "fixed_menus_available_for_check" CHECK (("available_for" = ANY (ARRAY['lunch'::"text", 'dinner'::"text", 'all'::"text"])))
);


ALTER TABLE "public"."fixed_menus" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_tenant_fixed_menus"("tid" "uuid") RETURNS SETOF "public"."fixed_menus"
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
    SELECT * FROM fixed_menus
    WHERE tenant_id = tid AND is_active = true
    ORDER BY sort_order;
  $$;


ALTER FUNCTION "public"."get_tenant_fixed_menus"("tid" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."menu_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "category_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "price" numeric(10,2) NOT NULL,
    "image_url" "text",
    "allergens" "text"[] DEFAULT '{}'::"text"[],
    "tags" "text"[] DEFAULT '{}'::"text"[],
    "is_available" boolean DEFAULT true,
    "is_active" boolean DEFAULT true,
    "preparation_time" integer,
    "calories" integer,
    "sort_order" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."menu_items" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_tenant_menu_items"("tid" "uuid") RETURNS SETOF "public"."menu_items"
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
    SELECT * FROM menu_items
    WHERE tenant_id = tid AND is_active = true AND is_available = true
    ORDER BY sort_order;
  $$;


ALTER FUNCTION "public"."get_tenant_menu_items"("tid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_restaurant_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
    SELECT tenant_id FROM users WHERE id = auth.uid()
  $$;


ALTER FUNCTION "public"."get_user_restaurant_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- Only create staff user if user_type is 'staff' or not specified
    -- (backwards compatible: existing staff signups without metadata still work)
    IF NEW.raw_user_meta_data->>'user_type' IS NULL
       OR NEW.raw_user_meta_data->>'user_type' = 'staff' THEN
        INSERT INTO public.users (id, email, restaurant_id, role)
        VALUES (
            NEW.id,
            NEW.email,
            'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
            'waiter'
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
    SELECT EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    )
  $$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_consumer"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.customers WHERE id = auth.uid()
    )
$$;


ALTER FUNCTION "public"."is_consumer"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."rls_auto_enable"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_review_comment"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    bad_words TEXT[] := ARRAY[
        'cazzo', 'merda', 'stronzo', 'puttana', 'vaffanculo', 'troia',
        'coglione', 'bastardo', 'porcodio', 'figadi',
        'fuck', 'shit', 'asshole', 'bitch', 'cunt', 'bastard'
    ];
    word TEXT;
    lowered TEXT;
BEGIN
    NEW.updated_at := NOW();

    IF NEW.comment IS NULL OR LENGTH(TRIM(NEW.comment)) = 0 THEN
        NEW.comment := NULL;
        RETURN NEW;
    END IF;

    IF LENGTH(NEW.comment) > 500 THEN
        RAISE EXCEPTION 'Comment too long (max 500 characters)';
    END IF;

    lowered := LOWER(NEW.comment);
    FOREACH word IN ARRAY bad_words LOOP
        -- \m / \M = word boundaries in Postgres regex
        IF lowered ~ ('\m' || word || '\M') THEN
            RAISE EXCEPTION 'Comment contains inappropriate language';
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validate_review_comment"() OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."customer_favorite_items" (
    "customer_id" "uuid" NOT NULL,
    "menu_item_id" "uuid" NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."customer_favorite_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."customer_favorite_restaurants" (
    "customer_id" "uuid" NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."customer_favorite_restaurants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."customers" (
    "id" "uuid" NOT NULL,
    "email" "text" NOT NULL,
    "display_name" "text",
    "phone" "text",
    "avatar_url" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "push_notifications_enabled" boolean DEFAULT true
);


ALTER TABLE "public"."customers" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."delivery_addresses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "label" "text" DEFAULT 'Casa'::"text",
    "street" "text" NOT NULL,
    "city" "text" NOT NULL,
    "postal_code" "text" NOT NULL,
    "province" "text",
    "country" "text" DEFAULT 'IT'::"text",
    "latitude" double precision,
    "longitude" double precision,
    "notes" "text",
    "is_default" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."delivery_addresses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."delivery_order_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "delivery_order_id" "uuid" NOT NULL,
    "menu_item_id" "uuid",
    "menu_item_name" "text" NOT NULL,
    "unit_price" numeric(10,2) NOT NULL,
    "quantity" integer DEFAULT 1 NOT NULL,
    "notes" "text",
    "status" "text" DEFAULT 'pending'::"text",
    "fixed_menu_id" "uuid",
    "fixed_menu_selections" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."delivery_order_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."delivery_orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "order_number" "text" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "subtotal" numeric(10,2) DEFAULT 0,
    "delivery_fee" numeric(10,2) DEFAULT 0,
    "discount" numeric(10,2) DEFAULT 0,
    "total" numeric(10,2) DEFAULT 0,
    "notes" "text",
    "delivery_street" "text" NOT NULL,
    "delivery_city" "text" NOT NULL,
    "delivery_postal_code" "text" NOT NULL,
    "delivery_province" "text",
    "delivery_latitude" double precision,
    "delivery_longitude" double precision,
    "delivery_notes" "text",
    "stripe_payment_intent_id" "text",
    "payment_status" "text" DEFAULT 'pending'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "confirmed_at" timestamp with time zone,
    "delivered_at" timestamp with time zone,
    "estimated_delivery_at" timestamp with time zone,
    CONSTRAINT "delivery_orders_payment_status_check" CHECK (("payment_status" = ANY (ARRAY['pending'::"text", 'paid'::"text", 'failed'::"text", 'refunded'::"text"]))),
    CONSTRAINT "delivery_orders_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'confirmed'::"text", 'preparing'::"text", 'ready_for_delivery'::"text", 'out_for_delivery'::"text", 'delivered'::"text", 'cancelled'::"text", 'refunded'::"text"])))
);


ALTER TABLE "public"."delivery_orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fixed_menu_choices" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "course_id" "uuid" NOT NULL,
    "menu_item_id" "uuid" NOT NULL,
    "menu_item_name" "text" NOT NULL,
    "supplement" numeric(10,2) DEFAULT 0,
    "is_default" boolean DEFAULT false,
    "sort_order" integer DEFAULT 0,
    "is_available" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."fixed_menu_choices" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fixed_menu_courses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "fixed_menu_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "sort_order" integer DEFAULT 0,
    "is_required" boolean DEFAULT true,
    "max_choices" integer DEFAULT 1,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."fixed_menu_courses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."order_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "menu_item_id" "uuid",
    "menu_item_name" "text" NOT NULL,
    "unit_price" numeric(10,2) NOT NULL,
    "quantity" integer DEFAULT 1 NOT NULL,
    "notes" "text",
    "status" "text" DEFAULT 'pending'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "fixed_menu_id" "uuid",
    "fixed_menu_selections" "jsonb",
    CONSTRAINT "order_items_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'preparing'::"text", 'ready'::"text", 'served'::"text"])))
);


ALTER TABLE "public"."order_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "table_id" "uuid" NOT NULL,
    "order_number" "text" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "subtotal" numeric(10,2) DEFAULT 0,
    "discount" numeric(10,2) DEFAULT 0,
    "total" numeric(10,2) DEFAULT 0,
    "notes" "text",
    "customer_name" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "confirmed_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "customer_id" "uuid",
    CONSTRAINT "orders_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'confirmed'::"text", 'preparing'::"text", 'ready'::"text", 'served'::"text", 'paid'::"text", 'cancelled'::"text"])))
);


ALTER TABLE "public"."orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."promo_codes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "code" "text" NOT NULL,
    "tenant_id" "uuid",
    "type" "text" NOT NULL,
    "value" numeric(10,2) NOT NULL,
    "min_order" numeric(10,2) DEFAULT 0 NOT NULL,
    "valid_from" timestamp with time zone DEFAULT "now"() NOT NULL,
    "valid_until" timestamp with time zone,
    "max_uses" integer,
    "uses_count" integer DEFAULT 0 NOT NULL,
    "per_customer_limit" integer DEFAULT 1 NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone,
    CONSTRAINT "promo_codes_type_check" CHECK (("type" = ANY (ARRAY['percent'::"text", 'fixed'::"text"]))),
    CONSTRAINT "promo_codes_value_check" CHECK (("value" > (0)::numeric))
);


ALTER TABLE "public"."promo_codes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."promo_redemptions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "promo_code_id" "uuid" NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "delivery_order_id" "uuid" NOT NULL,
    "discount_amount" numeric(10,2) NOT NULL,
    "redeemed_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."promo_redemptions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."push_tokens" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "token" "text" NOT NULL,
    "platform" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "last_seen_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "push_tokens_platform_check" CHECK (("platform" = ANY (ARRAY['android'::"text", 'ios'::"text", 'web'::"text"])))
);


ALTER TABLE "public"."push_tokens" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reviews" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "target_type" "text" NOT NULL,
    "target_id" "uuid" NOT NULL,
    "rating" smallint NOT NULL,
    "comment" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    CONSTRAINT "reviews_rating_check" CHECK ((("rating" >= 1) AND ("rating" <= 5))),
    CONSTRAINT "reviews_target_type_check" CHECK (("target_type" = ANY (ARRAY['restaurant'::"text", 'item'::"text"])))
);


ALTER TABLE "public"."reviews" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."review_aggregates" AS
 SELECT "target_type",
    "target_id",
    "round"("avg"("rating"), 1) AS "avg_rating",
    ("count"(*))::integer AS "review_count"
   FROM "public"."reviews"
  GROUP BY "target_type", "target_id";


ALTER VIEW "public"."review_aggregates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tenants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "logo_url" "text",
    "cover_image_url" "text",
    "address" "text",
    "phone" "text",
    "email" "text",
    "opening_hours" "jsonb" DEFAULT '{}'::"jsonb",
    "settings" "jsonb" DEFAULT '{}'::"jsonb",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "delivery_enabled" boolean DEFAULT false,
    "delivery_fee" numeric(10,2) DEFAULT 0,
    "delivery_radius_km" numeric(5,1) DEFAULT 5.0,
    "delivery_min_order" numeric(10,2) DEFAULT 0,
    "delivery_estimated_time_min" integer DEFAULT 45,
    "stripe_account_id" "text",
    "latitude" double precision,
    "longitude" double precision,
    "vacation_mode" boolean DEFAULT false,
    "cuisine_type" "text",
    "dietary_tags" "text"[] DEFAULT ARRAY[]::"text"[]
);


ALTER TABLE "public"."tenants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "email" "text" NOT NULL,
    "role" "text" DEFAULT 'waiter'::"text" NOT NULL,
    "first_name" "text",
    "last_name" "text",
    "avatar_url" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "last_login_at" timestamp with time zone,
    CONSTRAINT "users_role_check" CHECK (("role" = ANY (ARRAY['admin'::"text", 'manager'::"text", 'waiter'::"text", 'kitchen'::"text"])))
);


ALTER TABLE "public"."users" OWNER TO "postgres";


ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."customer_favorite_items"
    ADD CONSTRAINT "customer_favorite_items_pkey" PRIMARY KEY ("customer_id", "menu_item_id");



ALTER TABLE ONLY "public"."customer_favorite_restaurants"
    ADD CONSTRAINT "customer_favorite_restaurants_pkey" PRIMARY KEY ("customer_id", "tenant_id");



ALTER TABLE ONLY "public"."customers"
    ADD CONSTRAINT "customers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."delivery_addresses"
    ADD CONSTRAINT "delivery_addresses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."delivery_order_items"
    ADD CONSTRAINT "delivery_order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."delivery_orders"
    ADD CONSTRAINT "delivery_orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fixed_menu_choices"
    ADD CONSTRAINT "fixed_menu_choices_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fixed_menu_courses"
    ADD CONSTRAINT "fixed_menu_courses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fixed_menus"
    ADD CONSTRAINT "fixed_menus_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."menu_items"
    ADD CONSTRAINT "menu_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."promo_codes"
    ADD CONSTRAINT "promo_codes_code_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."promo_codes"
    ADD CONSTRAINT "promo_codes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."promo_redemptions"
    ADD CONSTRAINT "promo_redemptions_delivery_order_id_key" UNIQUE ("delivery_order_id");



ALTER TABLE ONLY "public"."promo_redemptions"
    ADD CONSTRAINT "promo_redemptions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."push_tokens"
    ADD CONSTRAINT "push_tokens_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."push_tokens"
    ADD CONSTRAINT "push_tokens_token_key" UNIQUE ("token");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "restaurants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_customer_id_target_type_target_id_key" UNIQUE ("customer_id", "target_type", "target_id");



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tables"
    ADD CONSTRAINT "tables_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tables"
    ADD CONSTRAINT "tables_qr_code_key" UNIQUE ("qr_code");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_categories_restaurant" ON "public"."categories" USING "btree" ("tenant_id");



CREATE INDEX "idx_customers_email" ON "public"."customers" USING "btree" ("email");



CREATE INDEX "idx_delivery_addresses_customer" ON "public"."delivery_addresses" USING "btree" ("customer_id");



CREATE INDEX "idx_delivery_order_items_order" ON "public"."delivery_order_items" USING "btree" ("delivery_order_id");



CREATE INDEX "idx_delivery_orders_customer" ON "public"."delivery_orders" USING "btree" ("customer_id");



CREATE INDEX "idx_delivery_orders_status" ON "public"."delivery_orders" USING "btree" ("status");



CREATE INDEX "idx_delivery_orders_tenant" ON "public"."delivery_orders" USING "btree" ("tenant_id");



CREATE INDEX "idx_fav_items_customer" ON "public"."customer_favorite_items" USING "btree" ("customer_id", "created_at" DESC);



CREATE INDEX "idx_fav_items_tenant" ON "public"."customer_favorite_items" USING "btree" ("tenant_id");



CREATE INDEX "idx_fav_restaurants_customer" ON "public"."customer_favorite_restaurants" USING "btree" ("customer_id", "created_at" DESC);



CREATE INDEX "idx_fav_restaurants_tenant" ON "public"."customer_favorite_restaurants" USING "btree" ("tenant_id");



CREATE INDEX "idx_fixed_menu_choices_course" ON "public"."fixed_menu_choices" USING "btree" ("course_id");



CREATE INDEX "idx_fixed_menu_choices_item" ON "public"."fixed_menu_choices" USING "btree" ("menu_item_id");



CREATE INDEX "idx_fixed_menu_courses_menu" ON "public"."fixed_menu_courses" USING "btree" ("fixed_menu_id");



CREATE INDEX "idx_fixed_menus_active" ON "public"."fixed_menus" USING "btree" ("is_active", "tenant_id");



CREATE INDEX "idx_fixed_menus_tenant" ON "public"."fixed_menus" USING "btree" ("tenant_id");



CREATE INDEX "idx_menu_items_category" ON "public"."menu_items" USING "btree" ("category_id");



CREATE INDEX "idx_menu_items_restaurant" ON "public"."menu_items" USING "btree" ("tenant_id");



CREATE INDEX "idx_order_items_fixed_menu" ON "public"."order_items" USING "btree" ("fixed_menu_id") WHERE ("fixed_menu_id" IS NOT NULL);



CREATE INDEX "idx_order_items_order" ON "public"."order_items" USING "btree" ("order_id");



CREATE INDEX "idx_orders_customer" ON "public"."orders" USING "btree" ("customer_id") WHERE ("customer_id" IS NOT NULL);



CREATE INDEX "idx_orders_restaurant" ON "public"."orders" USING "btree" ("tenant_id");



CREATE INDEX "idx_orders_status" ON "public"."orders" USING "btree" ("status");



CREATE INDEX "idx_orders_table" ON "public"."orders" USING "btree" ("table_id");



CREATE INDEX "idx_promo_codes_active" ON "public"."promo_codes" USING "btree" ("tenant_id", "active") WHERE ("active" = true);



CREATE INDEX "idx_promo_codes_code" ON "public"."promo_codes" USING "btree" ("code");



CREATE INDEX "idx_promo_codes_tenant" ON "public"."promo_codes" USING "btree" ("tenant_id") WHERE ("tenant_id" IS NOT NULL);



CREATE INDEX "idx_push_tokens_customer" ON "public"."push_tokens" USING "btree" ("customer_id");



CREATE INDEX "idx_redemptions_customer" ON "public"."promo_redemptions" USING "btree" ("customer_id");



CREATE INDEX "idx_redemptions_promo" ON "public"."promo_redemptions" USING "btree" ("promo_code_id");



CREATE INDEX "idx_reviews_customer" ON "public"."reviews" USING "btree" ("customer_id");



CREATE INDEX "idx_reviews_target" ON "public"."reviews" USING "btree" ("target_type", "target_id");



CREATE INDEX "idx_tables_qr_code" ON "public"."tables" USING "btree" ("qr_code");



CREATE INDEX "idx_tables_restaurant" ON "public"."tables" USING "btree" ("tenant_id");



CREATE INDEX "idx_tenants_cuisine_type" ON "public"."tenants" USING "btree" ("cuisine_type") WHERE ("delivery_enabled" = true);



CREATE INDEX "idx_tenants_delivery_enabled" ON "public"."tenants" USING "btree" ("delivery_enabled") WHERE ("delivery_enabled" = true);



CREATE INDEX "idx_tenants_dietary_tags" ON "public"."tenants" USING "gin" ("dietary_tags") WHERE ("delivery_enabled" = true);



CREATE INDEX "idx_tenants_geo" ON "public"."tenants" USING "btree" ("latitude", "longitude") WHERE (("latitude" IS NOT NULL) AND ("longitude" IS NOT NULL));



CREATE INDEX "idx_tenants_vacation_mode" ON "public"."tenants" USING "btree" ("vacation_mode") WHERE ("vacation_mode" = true);



CREATE INDEX "idx_users_restaurant" ON "public"."users" USING "btree" ("tenant_id");



-- NOTE: This webhook fires the send-order-push edge function on delivery_orders UPDATE.
-- The Authorization Bearer token below has been REDACTED — it was the project's
-- service_role JWT. The buyer must recreate this webhook in their own project
-- (Dashboard > Database > Webhooks) using THEIR service_role key.
CREATE OR REPLACE TRIGGER "delivery_orders_push" AFTER UPDATE ON "public"."delivery_orders" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://<YOUR_PROJECT_REF>.supabase.co/functions/v1/send-order-push', 'POST', '{"Content-type":"application/json","Authorization":"Bearer <YOUR_SERVICE_ROLE_JWT>"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "trg_validate_review_comment" BEFORE INSERT OR UPDATE ON "public"."reviews" FOR EACH ROW EXECUTE FUNCTION "public"."validate_review_comment"();



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_restaurant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer_favorite_items"
    ADD CONSTRAINT "customer_favorite_items_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer_favorite_items"
    ADD CONSTRAINT "customer_favorite_items_menu_item_id_fkey" FOREIGN KEY ("menu_item_id") REFERENCES "public"."menu_items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer_favorite_items"
    ADD CONSTRAINT "customer_favorite_items_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer_favorite_restaurants"
    ADD CONSTRAINT "customer_favorite_restaurants_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customer_favorite_restaurants"
    ADD CONSTRAINT "customer_favorite_restaurants_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."customers"
    ADD CONSTRAINT "customers_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."delivery_addresses"
    ADD CONSTRAINT "delivery_addresses_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."delivery_order_items"
    ADD CONSTRAINT "delivery_order_items_delivery_order_id_fkey" FOREIGN KEY ("delivery_order_id") REFERENCES "public"."delivery_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."delivery_order_items"
    ADD CONSTRAINT "delivery_order_items_fixed_menu_id_fkey" FOREIGN KEY ("fixed_menu_id") REFERENCES "public"."fixed_menus"("id");



ALTER TABLE ONLY "public"."delivery_order_items"
    ADD CONSTRAINT "delivery_order_items_menu_item_id_fkey" FOREIGN KEY ("menu_item_id") REFERENCES "public"."menu_items"("id");



ALTER TABLE ONLY "public"."delivery_orders"
    ADD CONSTRAINT "delivery_orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id");



ALTER TABLE ONLY "public"."delivery_orders"
    ADD CONSTRAINT "delivery_orders_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fixed_menu_choices"
    ADD CONSTRAINT "fixed_menu_choices_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "public"."fixed_menu_courses"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fixed_menu_choices"
    ADD CONSTRAINT "fixed_menu_choices_menu_item_id_fkey" FOREIGN KEY ("menu_item_id") REFERENCES "public"."menu_items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fixed_menu_courses"
    ADD CONSTRAINT "fixed_menu_courses_fixed_menu_id_fkey" FOREIGN KEY ("fixed_menu_id") REFERENCES "public"."fixed_menus"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fixed_menus"
    ADD CONSTRAINT "fixed_menus_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_items"
    ADD CONSTRAINT "menu_items_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."menu_items"
    ADD CONSTRAINT "menu_items_restaurant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_fixed_menu_id_fkey" FOREIGN KEY ("fixed_menu_id") REFERENCES "public"."fixed_menus"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_menu_item_id_fkey" FOREIGN KEY ("menu_item_id") REFERENCES "public"."menu_items"("id");



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_restaurant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_table_id_fkey" FOREIGN KEY ("table_id") REFERENCES "public"."tables"("id");



ALTER TABLE ONLY "public"."promo_codes"
    ADD CONSTRAINT "promo_codes_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_redemptions"
    ADD CONSTRAINT "promo_redemptions_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_redemptions"
    ADD CONSTRAINT "promo_redemptions_delivery_order_id_fkey" FOREIGN KEY ("delivery_order_id") REFERENCES "public"."delivery_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."promo_redemptions"
    ADD CONSTRAINT "promo_redemptions_promo_code_id_fkey" FOREIGN KEY ("promo_code_id") REFERENCES "public"."promo_codes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."push_tokens"
    ADD CONSTRAINT "push_tokens_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tables"
    ADD CONSTRAINT "tables_restaurant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_restaurant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



CREATE POLICY "Allow public read tables by qr_code" ON "public"."tables" FOR SELECT TO "anon" USING (("is_active" = true));



CREATE POLICY "Anon can view active categories" ON "public"."categories" FOR SELECT TO "anon" USING (("is_active" = true));



CREATE POLICY "Anon can view active fixed menus" ON "public"."fixed_menus" FOR SELECT TO "anon" USING (("is_active" = true));



CREATE POLICY "Anon can view active menu" ON "public"."menu_items" FOR SELECT TO "anon" USING (("is_active" = true));



CREATE POLICY "Anon can view choices" ON "public"."fixed_menu_choices" FOR SELECT TO "anon" USING (true);



CREATE POLICY "Anon can view courses" ON "public"."fixed_menu_courses" FOR SELECT TO "anon" USING (true);



CREATE POLICY "Consumer can view active categories" ON "public"."categories" FOR SELECT TO "authenticated" USING ((("is_active" = true) AND "public"."is_consumer"()));



CREATE POLICY "Consumer can view active fixed menus" ON "public"."fixed_menus" FOR SELECT TO "authenticated" USING ((("is_active" = true) AND "public"."is_consumer"()));



CREATE POLICY "Consumer can view active menu" ON "public"."menu_items" FOR SELECT TO "authenticated" USING ((("is_active" = true) AND "public"."is_consumer"()));



CREATE POLICY "Consumer can view choices" ON "public"."fixed_menu_choices" FOR SELECT TO "authenticated" USING ("public"."is_consumer"());



CREATE POLICY "Consumer can view courses" ON "public"."fixed_menu_courses" FOR SELECT TO "authenticated" USING ("public"."is_consumer"());



CREATE POLICY "Consumer can view delivery restaurants" ON "public"."tenants" FOR SELECT TO "authenticated" USING ((("delivery_enabled" = true) AND "public"."is_consumer"()));



CREATE POLICY "Customers can insert own profile" ON "public"."customers" FOR INSERT WITH CHECK (("id" = "auth"."uid"()));



CREATE POLICY "Customers can update own profile" ON "public"."customers" FOR UPDATE USING (("id" = "auth"."uid"()));



CREATE POLICY "Customers can view own profile" ON "public"."customers" FOR SELECT USING (("id" = "auth"."uid"()));



CREATE POLICY "Customers create delivery order items" ON "public"."delivery_order_items" FOR INSERT WITH CHECK (("delivery_order_id" IN ( SELECT "delivery_orders"."id"
   FROM "public"."delivery_orders"
  WHERE ("delivery_orders"."customer_id" = "auth"."uid"()))));



CREATE POLICY "Customers create delivery orders" ON "public"."delivery_orders" FOR INSERT WITH CHECK (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers create own reviews after delivery" ON "public"."reviews" FOR INSERT TO "authenticated" WITH CHECK ((("customer_id" = "auth"."uid"()) AND ((("target_type" = 'restaurant'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."delivery_orders"
  WHERE (("delivery_orders"."customer_id" = "auth"."uid"()) AND ("delivery_orders"."tenant_id" = "reviews"."target_id") AND ("delivery_orders"."status" = 'delivered'::"text"))))) OR (("target_type" = 'item'::"text") AND (EXISTS ( SELECT 1
   FROM ("public"."delivery_order_items" "doi"
     JOIN "public"."delivery_orders" "d" ON (("d"."id" = "doi"."delivery_order_id")))
  WHERE (("d"."customer_id" = "auth"."uid"()) AND ("d"."status" = 'delivered'::"text") AND ("doi"."menu_item_id" = "reviews"."target_id"))))))));



CREATE POLICY "Customers delete own reviews" ON "public"."reviews" FOR DELETE TO "authenticated" USING (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers manage own addresses" ON "public"."delivery_addresses" USING (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers manage own favorite items" ON "public"."customer_favorite_items" USING (("customer_id" = "auth"."uid"())) WITH CHECK (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers manage own favorite restaurants" ON "public"."customer_favorite_restaurants" USING (("customer_id" = "auth"."uid"())) WITH CHECK (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers manage own push tokens" ON "public"."push_tokens" USING (("customer_id" = "auth"."uid"())) WITH CHECK (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers update own reviews" ON "public"."reviews" FOR UPDATE TO "authenticated" USING (("customer_id" = "auth"."uid"())) WITH CHECK (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers view own delivery order items" ON "public"."delivery_order_items" FOR SELECT USING (("delivery_order_id" IN ( SELECT "delivery_orders"."id"
   FROM "public"."delivery_orders"
  WHERE ("delivery_orders"."customer_id" = "auth"."uid"()))));



CREATE POLICY "Customers view own delivery orders" ON "public"."delivery_orders" FOR SELECT USING (("customer_id" = "auth"."uid"()));



CREATE POLICY "Customers view own redemptions" ON "public"."promo_redemptions" FOR SELECT TO "authenticated" USING (("customer_id" = "auth"."uid"()));



CREATE POLICY "Reviews public read" ON "public"."reviews" FOR SELECT USING (true);



CREATE POLICY "Staff can manage choices" ON "public"."fixed_menu_choices" USING (("course_id" IN ( SELECT "fmc"."id"
   FROM ("public"."fixed_menu_courses" "fmc"
     JOIN "public"."fixed_menus" "fm" ON (("fmc"."fixed_menu_id" = "fm"."id")))
  WHERE ("fm"."tenant_id" IN ( SELECT "users"."tenant_id"
           FROM "public"."users"
          WHERE ("users"."id" = "auth"."uid"()))))));



CREATE POLICY "Staff can manage courses" ON "public"."fixed_menu_courses" USING (("fixed_menu_id" IN ( SELECT "fixed_menus"."id"
   FROM "public"."fixed_menus"
  WHERE ("fixed_menus"."tenant_id" IN ( SELECT "users"."tenant_id"
           FROM "public"."users"
          WHERE ("users"."id" = "auth"."uid"()))))));



CREATE POLICY "Staff can manage fixed menus" ON "public"."fixed_menus" USING (("tenant_id" IN ( SELECT "users"."tenant_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Staff can update own tenant" ON "public"."tenants" FOR UPDATE USING (("id" = ( SELECT "users"."tenant_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



CREATE POLICY "Staff can view own tenant choices" ON "public"."fixed_menu_choices" FOR SELECT TO "authenticated" USING (("course_id" IN ( SELECT "fmc"."id"
   FROM ("public"."fixed_menu_courses" "fmc"
     JOIN "public"."fixed_menus" "fm" ON (("fmc"."fixed_menu_id" = "fm"."id")))
  WHERE ("fm"."tenant_id" = ( SELECT "users"."tenant_id"
           FROM "public"."users"
          WHERE ("users"."id" = "auth"."uid"()))))));



CREATE POLICY "Staff can view own tenant courses" ON "public"."fixed_menu_courses" FOR SELECT TO "authenticated" USING (("fixed_menu_id" IN ( SELECT "fixed_menus"."id"
   FROM "public"."fixed_menus"
  WHERE ("fixed_menus"."tenant_id" = ( SELECT "users"."tenant_id"
           FROM "public"."users"
          WHERE ("users"."id" = "auth"."uid"()))))));



CREATE POLICY "Staff manage delivery order items" ON "public"."delivery_order_items" USING (("delivery_order_id" IN ( SELECT "delivery_orders"."id"
   FROM "public"."delivery_orders"
  WHERE ("delivery_orders"."tenant_id" = "public"."get_user_restaurant_id"()))));



CREATE POLICY "Staff manage own tenant promo codes" ON "public"."promo_codes" TO "authenticated" USING (("tenant_id" = "public"."get_user_restaurant_id"())) WITH CHECK (("tenant_id" = "public"."get_user_restaurant_id"()));



CREATE POLICY "Staff manage restaurant delivery orders" ON "public"."delivery_orders" USING (("tenant_id" = "public"."get_user_restaurant_id"()));



CREATE POLICY "Staff view own tenant redemptions" ON "public"."promo_redemptions" FOR SELECT TO "authenticated" USING (("promo_code_id" IN ( SELECT "promo_codes"."id"
   FROM "public"."promo_codes"
  WHERE ("promo_codes"."tenant_id" = "public"."get_user_restaurant_id"()))));



CREATE POLICY "Users can view own tenant fixed menus" ON "public"."fixed_menus" FOR SELECT USING (("tenant_id" IN ( SELECT "users"."tenant_id"
   FROM "public"."users"
  WHERE ("users"."id" = "auth"."uid"()))));



ALTER TABLE "public"."categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."customer_favorite_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."customer_favorite_restaurants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."customers" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."delivery_addresses" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."delivery_order_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."delivery_orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."fixed_menu_choices" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."fixed_menu_courses" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."fixed_menus" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."menu_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."order_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."promo_codes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."promo_redemptions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."push_tokens" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reviews" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tables" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tenant_insert" ON "public"."tenants" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "tenant_isolation" ON "public"."categories" TO "authenticated" USING (("tenant_id" = "public"."get_my_tenant_id"())) WITH CHECK (("tenant_id" = "public"."get_my_tenant_id"()));



CREATE POLICY "tenant_isolation" ON "public"."menu_items" TO "authenticated" USING (("tenant_id" = "public"."get_my_tenant_id"())) WITH CHECK (("tenant_id" = "public"."get_my_tenant_id"()));



CREATE POLICY "tenant_isolation" ON "public"."order_items" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."orders"
  WHERE (("orders"."id" = "order_items"."order_id") AND ("orders"."tenant_id" = "public"."get_my_tenant_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."orders"
  WHERE (("orders"."id" = "order_items"."order_id") AND ("orders"."tenant_id" = "public"."get_my_tenant_id"())))));



CREATE POLICY "tenant_isolation" ON "public"."orders" TO "authenticated" USING (("tenant_id" = "public"."get_my_tenant_id"())) WITH CHECK (("tenant_id" = "public"."get_my_tenant_id"()));



CREATE POLICY "tenant_isolation" ON "public"."tables" TO "authenticated" USING (("tenant_id" = "public"."get_my_tenant_id"())) WITH CHECK (("tenant_id" = "public"."get_my_tenant_id"()));



CREATE POLICY "tenant_isolation" ON "public"."tenants" FOR SELECT TO "authenticated" USING (("id" = "public"."get_my_tenant_id"()));



CREATE POLICY "tenant_isolation" ON "public"."users" TO "authenticated" USING ((("tenant_id" = "public"."get_my_tenant_id"()) OR ("id" = "auth"."uid"()))) WITH CHECK ((("tenant_id" = "public"."get_my_tenant_id"()) OR ("id" = "auth"."uid"())));



ALTER TABLE "public"."tenants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."delivery_order_items";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."delivery_orders";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."fixed_menu_choices";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."fixed_menu_courses";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."fixed_menus";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."order_items";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."orders";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."promo_codes";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






















































































































































GRANT ALL ON FUNCTION "public"."get_my_restaurant_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_restaurant_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_restaurant_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_my_tenant_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_tenant_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_tenant_id"() TO "service_role";



GRANT ALL ON TABLE "public"."tables" TO "anon";
GRANT ALL ON TABLE "public"."tables" TO "authenticated";
GRANT ALL ON TABLE "public"."tables" TO "service_role";



GRANT ALL ON FUNCTION "public"."get_table_by_qr"("qr" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_table_by_qr"("qr" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_table_by_qr"("qr" "text") TO "service_role";



GRANT ALL ON TABLE "public"."categories" TO "anon";
GRANT ALL ON TABLE "public"."categories" TO "authenticated";
GRANT ALL ON TABLE "public"."categories" TO "service_role";



GRANT ALL ON FUNCTION "public"."get_tenant_categories"("tid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_tenant_categories"("tid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_tenant_categories"("tid" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."fixed_menus" TO "anon";
GRANT ALL ON TABLE "public"."fixed_menus" TO "authenticated";
GRANT ALL ON TABLE "public"."fixed_menus" TO "service_role";



GRANT ALL ON FUNCTION "public"."get_tenant_fixed_menus"("tid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_tenant_fixed_menus"("tid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_tenant_fixed_menus"("tid" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."menu_items" TO "anon";
GRANT ALL ON TABLE "public"."menu_items" TO "authenticated";
GRANT ALL ON TABLE "public"."menu_items" TO "service_role";



GRANT ALL ON FUNCTION "public"."get_tenant_menu_items"("tid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_tenant_menu_items"("tid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_tenant_menu_items"("tid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_user_restaurant_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_restaurant_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_restaurant_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_consumer"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_consumer"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_consumer"() TO "service_role";



GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "anon";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validate_review_comment"() TO "anon";
GRANT ALL ON FUNCTION "public"."validate_review_comment"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validate_review_comment"() TO "service_role";


















GRANT ALL ON TABLE "public"."customer_favorite_items" TO "anon";
GRANT ALL ON TABLE "public"."customer_favorite_items" TO "authenticated";
GRANT ALL ON TABLE "public"."customer_favorite_items" TO "service_role";



GRANT ALL ON TABLE "public"."customer_favorite_restaurants" TO "anon";
GRANT ALL ON TABLE "public"."customer_favorite_restaurants" TO "authenticated";
GRANT ALL ON TABLE "public"."customer_favorite_restaurants" TO "service_role";



GRANT ALL ON TABLE "public"."customers" TO "anon";
GRANT ALL ON TABLE "public"."customers" TO "authenticated";
GRANT ALL ON TABLE "public"."customers" TO "service_role";



GRANT ALL ON TABLE "public"."delivery_addresses" TO "anon";
GRANT ALL ON TABLE "public"."delivery_addresses" TO "authenticated";
GRANT ALL ON TABLE "public"."delivery_addresses" TO "service_role";



GRANT ALL ON TABLE "public"."delivery_order_items" TO "anon";
GRANT ALL ON TABLE "public"."delivery_order_items" TO "authenticated";
GRANT ALL ON TABLE "public"."delivery_order_items" TO "service_role";



GRANT ALL ON TABLE "public"."delivery_orders" TO "anon";
GRANT ALL ON TABLE "public"."delivery_orders" TO "authenticated";
GRANT ALL ON TABLE "public"."delivery_orders" TO "service_role";



GRANT ALL ON TABLE "public"."fixed_menu_choices" TO "anon";
GRANT ALL ON TABLE "public"."fixed_menu_choices" TO "authenticated";
GRANT ALL ON TABLE "public"."fixed_menu_choices" TO "service_role";



GRANT ALL ON TABLE "public"."fixed_menu_courses" TO "anon";
GRANT ALL ON TABLE "public"."fixed_menu_courses" TO "authenticated";
GRANT ALL ON TABLE "public"."fixed_menu_courses" TO "service_role";



GRANT ALL ON TABLE "public"."order_items" TO "anon";
GRANT ALL ON TABLE "public"."order_items" TO "authenticated";
GRANT ALL ON TABLE "public"."order_items" TO "service_role";



GRANT ALL ON TABLE "public"."orders" TO "anon";
GRANT ALL ON TABLE "public"."orders" TO "authenticated";
GRANT ALL ON TABLE "public"."orders" TO "service_role";



GRANT ALL ON TABLE "public"."promo_codes" TO "anon";
GRANT ALL ON TABLE "public"."promo_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."promo_codes" TO "service_role";



GRANT ALL ON TABLE "public"."promo_redemptions" TO "anon";
GRANT ALL ON TABLE "public"."promo_redemptions" TO "authenticated";
GRANT ALL ON TABLE "public"."promo_redemptions" TO "service_role";



GRANT ALL ON TABLE "public"."push_tokens" TO "anon";
GRANT ALL ON TABLE "public"."push_tokens" TO "authenticated";
GRANT ALL ON TABLE "public"."push_tokens" TO "service_role";



GRANT ALL ON TABLE "public"."reviews" TO "anon";
GRANT ALL ON TABLE "public"."reviews" TO "authenticated";
GRANT ALL ON TABLE "public"."reviews" TO "service_role";



GRANT ALL ON TABLE "public"."review_aggregates" TO "anon";
GRANT ALL ON TABLE "public"."review_aggregates" TO "authenticated";
GRANT ALL ON TABLE "public"."review_aggregates" TO "service_role";



GRANT ALL ON TABLE "public"."tenants" TO "anon";
GRANT ALL ON TABLE "public"."tenants" TO "authenticated";
GRANT ALL ON TABLE "public"."tenants" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";


-- =====================================================================
-- MANUALLY ADDED — not produced by `supabase db dump`
-- =====================================================================
-- `db dump` only exports the `public` schema, so the trigger that binds
-- handle_new_user() to auth.users is omitted. Without it, new staff
-- sign-ups never get their public.users row created. Recreate it here.
DROP TRIGGER IF EXISTS "on_auth_user_created" ON "auth"."users";
CREATE TRIGGER "on_auth_user_created"
    AFTER INSERT ON "auth"."users"
    FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_user"();



































