import { test_each_by_fold, test_each, test_iter_each, test_each_by_map,
    test_collect, test_collect_by_fold, test_iter_collect,
    test_filter, test_filter_by_fold, test_iter_filter,
 } from "./iter.wasm"

Deno.bench("test_iter_each", { "group": "each" }, test_iter_each)
Deno.bench("test_each_by_fold", { "group": "each" }, test_each_by_fold)
Deno.bench("test_each", { "group": "each" }, test_each)
Deno.bench("test_each_by_map", { "group": "each" }, test_each_by_map)
Deno.bench("test_collect", { "group": "collect" }, test_collect)
Deno.bench("test_collect_by_fold", { "group": "collect" }, test_collect_by_fold)
Deno.bench("test_iter_collect", { "group": "collect" }, test_iter_collect)
Deno.bench("test_filter", { "group": "filter" }, test_filter)
Deno.bench("test_filter_by_fold", { "group": "filter" }, test_filter_by_fold)
Deno.bench("test_iter_filter", { "group": "filter" }, test_iter_filter)