local function prequire(...)
local status, lib = pcall(require, ...)
if (status) then return lib end
    return nil
end

local luasnip = prequire('luasnip')

_G.expand_or_jump = function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end

_G.jump_previous = function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end

_G.change_choice = function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end

vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-or-jump", {})
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-or-jump", {})
vim.api.nvim_set_keymap("i", "<C-d>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("s", "<C-d>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("i", "<C-a>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("s", "<C-a>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("i", "<C-c>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-c>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-x>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-x>", "<Plug>luasnip-prev-choice", {})

local fmt = require"luasnip.extras.fmt".fmt
local s = luasnip.snippet
local i = luasnip.insert_node
local t = luasnip.text_node
local f = luasnip.function_node
local c = luasnip.choice_node
local r = require"luasnip.extras".rep
local u = function (index)
    return f(function(args)
        return args[index][1]:upper()
    end, { index })
end
local l = function (index)
    return f(function(args)
        return args[index][1]:lower()
    end, { index })
end

luasnip.snippets = {
    typescript = {
        s('type', {
            t('export type '), i(1, ''), t({' = {' , '    '}), i(0, ''), t({'', '}'}),
        }),
        s('tp', {
            i(1, ''), t(': '), c(2, {t 'string', t 'number', t 'boolean'}), t(';'), i(0)
        }),
        s('slicer',
            fmt([[
                import {{ createSlice, PayloadAction }} from "@reduxjs/toolkit";
                import _ from "lodash";
                import {{ {}s }} from '../../models';

                const initialState: {}s[] = [];

                export const {}sSlicer = createSlice({{
                    name: '{}S',
                    initialState,
                    reducers: {{
                        SET_{}S: (state, action: PayloadAction<{}s[]>) => {{
                            state = _.merge(state, action.payload);
                        }},
                        ADD_{}: (state, action: PayloadAction<{}s>) => {{
                            state.push(action.payload);
                        }},
                        REMOVE_{}: (state, action: PayloadAction<{}>) => {{
                            state.filter({} => {{
                                return {}.{} !== action.payload;
                            }});
                        }},
                        UPDATE_{}: (state, action: PayloadAction<{}s>) => {{
                            state = state.map({} => {{
                                if ({}.{} === action.payload.{}) {{
                                    return _.merge({}, action.payload);
                                }}
                                return {};
                            }});
                        }},
                    }},
                }});

                export const {{
                    SET_{}S,
                    ADD_{},
                    REMOVE_{},
                    UPDATE_{},
                }} = {}sSlicer.actions;

                export const {}sReducer = {}sSlicer.reducer;
            ]], {
                i(1),
                r(1),
                r(1),
                u(1),
                u(1),
                r(1),
                u(1),
                r(1),
                u(1),
                c(2, {
                    t('string'),
                    t('number'),
                }),
                l(1),
                l(1),
                i(3, 'id'),
                u(1),
                r(1),
                l(1),
                l(1),
                r(3),
                r(3),
                l(1),
                l(1),
                u(1),
                u(1),
                u(1),
                u(1),
                r(1),
                r(1),
                r(1),
            })
        ),
        s('saga',
            fmt([[
                import {{ put, all, takeLatest, delay, race, call }} from 'redux-saga/effects';
                import _ from 'lodash';
                import {{ createAction }} from '@reduxjs/toolkit';
                import {{ {}s }} from '../../models';
                import {{ ADD_{}, DELETE_{}, SET_{}S, SET_FETCHING, SET_SUBMITTING, UPDATE_{} }} from '../slicers';
                import {{ {}sService }} from '../../services';
                import {{ AxiosResponse }} from 'axios';
                import {{ TOGGLE_ACTION_ERROR_ACTION, TOGGLE_ACTION_SUCCESS_ACTION }} from './app.saga';
                import {{ Filter }} from '@loopback/repository';

                export const ADD_{}_ACTION = createAction('ADD_{}_ACTION', (payload: {}s, pathParams?: {{ [key: string]: {} }}) => ({{
                    payload: {{
                        payload,
                        pathParams,
                    }}
                }}));

                export function* add{}Saga(action: ReturnType<typeof ADD_{}_ACTION>) {{
                    yield put(SET_SUBMITTING(true));
                    try {{
                        type RaceResult = {{
                            result: AxiosResponse<{}s>
                        }}
                        const {{ result }}: RaceResult = yield race({{
                            result: call({}sService.create, action.payload.payload, action.payload.pathParams),
                            timeout: delay(5000)
                        }});
                        if (result) {{
                            yield put(ADD_{}(result.data));
                            yield put(TOGGLE_ACTION_SUCCESS_ACTION('actions.{}s.success.add'));
                        }} else {{
                            yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.timeout'));
                        }}
                    }} catch (_) {{
                        yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.invalid'));
                    }}
                    yield put(SET_SUBMITTING(false));
                }}

                export function* watchAdd{}Saga() {{
                    yield takeLatest(ADD_{}_ACTION.toString(), add{}Saga);
                }}

                export const DELETE_{}_ACTION = createAction('DELETE_{}_ACTION', ({}: {}, pathParams?: {{ [key: string]: {} }}) => ({{
                    payload: {{
                        {},
                        pathParams,
                    }}
                }}));

                export function* delete{}Saga(action: ReturnType<typeof DELETE_{}_ACTION>) {{
                    yield put(SET_SUBMITTING(true));
                    try {{
                        type RaceResult = {{
                            result: AxiosResponse<{}s>
                        }}
                        const {{ result }}: RaceResult = yield race({{
                            result: call({}sService.delete, action.payload.{}, action.payload.pathParams),
                            timeout: delay(5000)
                        }});
                        if (result) {{
                            yield put(DELETE_{}(action.payload.{}));
                            yield put(TOGGLE_ACTION_SUCCESS_ACTION('actions.{}s.success.delete'));
                        }} else {{
                            yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.timeout'));
                        }}
                    }} catch (_) {{
                        yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.invalid'));
                    }}
                    yield put(SET_SUBMITTING(false));
                }}

                export function* watchDelete{}Saga() {{
                    yield takeLatest(DELETE_{}_ACTION.toString(), delete{}Saga);
                }}

                export const UPDATE_{}_ACTION = createAction('UPDATE_{}_ACTION', ({}: {}, payload: {}s, pathParams?: {{ [key: string]: {} }}) => ({{
                    payload: {{
                        {},
                        payload,
                        pathParams
                    }}
                }}));

                export function* update{}Saga(action: ReturnType<typeof UPDATE_{}_ACTION>) {{
                    yield put(SET_SUBMITTING(true));
                    try {{
                        type RaceResult = {{
                            result: AxiosResponse<{}s>
                        }}
                        const {{ result }}: RaceResult = yield race({{
                            result: call({}sService.update, action.payload.{}, action.payload.payload, action.payload.pathParams),
                            timeout: delay(5000)
                        }});
                        if (result) {{
                            yield put(UPDATE_{}(result.data));
                            yield put(TOGGLE_ACTION_SUCCESS_ACTION('actions.{}s.success.update'));
                        }} else {{
                            yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.timeout'));
                        }}
                    }} catch (_) {{
                        yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.invalid'));
                    }}
                    yield put(SET_SUBMITTING(false));
                }}

                export function* watchUpdate{}Saga() {{
                    yield takeLatest(UPDATE_{}_ACTION.toString(), update{}Saga);
                }}

                export const FETCH_{}S_ACTION = createAction('FETCH_{}S_ACTION', (filter?: Filter<{}s>, pathParams?: {{ [key: string]: {} }}) => ({{
                    payload: {{
                        filter,
                        pathParams,
                    }}
                }}));

                export function* fetch{}sSaga(action: ReturnType<typeof FETCH_{}S_ACTION>) {{
                    yield put(SET_FETCHING(true));
                    try {{
                        type RaceResult = {{
                            result: AxiosResponse<{}s[]>
                        }}
                        const {{ result }}: RaceResult = yield race({{
                            result: call({}sService.fetchAll, action.payload.filter, action.payload.pathParams),
                            timeout: delay(5000)
                        }});
                        if (result) {{
                            yield put(SET_{}S(result.data));
                        }} else {{
                            yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.timeout'));
                        }}
                    }} catch (_) {{
                        yield put(TOGGLE_ACTION_ERROR_ACTION('actions.{}s.errors.invalid'));
                    }}
                    yield put(SET_FETCHING(false));
                }}

                export function* watchFetch{}sSaga() {{
                    yield takeLatest(FETCH_{}S_ACTION.toString(), fetch{}sSaga);
                }}

                export function* watch{}sSagas() {{
                    yield all([
                        watchAdd{}Saga(),
                        watchDelete{}Saga(),
                        watchUpdate{}Saga(),
                        watchFetch{}sSaga(),
                    ]);
                }}
            ]], {
                    i(1),
                    u(1),
                    u(1),
                    u(1),
                    u(1),
                    l(1),
                    u(1),
                    u(1),
                    r(1),
                    c(2, {
                        t('number'),
                        t('string'),
                    }),
                    r(1),
                    u(1),
                    r(1),
                    l(1),
                    u(1),
                    l(1),
                    l(1),
                    l(1),
                    r(1),
                    u(1),
                    r(1),
                    u(1), -- DELETE
                    u(1),
                    i(3, 'id'),
                    r(2),
                    r(2),
                    r(3),
                    r(1),
                    u(1),
                    r(1),
                    l(1),
                    r(3),
                    u(1),
                    r(3),
                    l(1),
                    l(1),
                    l(1),
                    r(1),
                    u(1),
                    r(1),
                    u(1), -- UPDATE
                    u(1),
                    r(3),
                    r(2),
                    r(1),
                    r(2),
                    r(3),
                    r(1),
                    u(1),
                    r(1),
                    l(1),
                    r(3),
                    u(1),
                    l(1),
                    l(1),
                    l(1),
                    r(1),
                    u(1),
                    r(1),
                    u(1), -- FETCH
                    u(1),
                    r(1),
                    r(2),
                    r(1),
                    u(1),
                    r(1),
                    l(1),
                    u(1),
                    l(1),
                    l(1),
                    r(1),
                    u(1),
                    r(1),
                    r(1),
                    r(1),
                    r(1),
                    r(1),
                    r(1),
            })
        ),
    }
}

require("luasnip.loaders.from_vscode").load({ paths = { vim.env.CWD .. "/vsnip", vim.env.CWD .. "/plugged/friendly-snippets" } })
