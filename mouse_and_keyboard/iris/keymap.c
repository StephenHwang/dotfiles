#include QMK_KEYBOARD_H

// Iris keymap
// xev to check keypresses

#define _QWERTY 0
#define _LOWER 1
#define _RAISE 2
#define _ADJUST 3

#define ARW 0x2192 // →
#define DSH 0x2014 // —

enum custom_keycodes {
  QWERTY = SAFE_RANGE, // 0
  LOWER,               // 1
  RAISE,               // 2
  ADJUST,              // 3
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

  [_QWERTY] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┐
     KC_ESC,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                               KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS,
  //├────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┤
     KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                               KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_ENT,
  //├────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┤
     KC_LSFT, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                               KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,
  //├────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┤
     KC_LCTL, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_CAPS,          KC_LGUI,  KC_N,   KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_SLSH,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┬────┴───┬────┘        └───┬────┴───┬────┴───┬────┴───┬────┴────────┴────────┴────────┘
                                    KC_LALT, LOWER,   RAISE,                     KC_BTN1, KC_SPC,  KC_BSPC
                                // └────────┴────────┴────────┘                 └────────┴────────┴────────┘
  ),

  [_LOWER] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┐
     _______, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,                            KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, UC(DSH),
  //├────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┤
     _______, KC_QUES, KC_GRV,  KC_LPRN, KC_RPRN, KC_TILD,                            KC_HOME, KC_END,  KC_LCBR, KC_RCBR, KC_BSLS, _______,
  //├────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┤
     _______, KC_EXLM, KC_PERC, KC_MINS, KC_UNDS, KC_PEQL,                            KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, KC_DQUO,
  //├────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┤
     UC(ARW), KC_CIRC, KC_DLR,  KC_HASH, KC_PLUS, KC_ASTR, KC_VOLU,          KC_BRIU, KC_LBRC, KC_RBRC, KC_LT,   KC_GT,   KC_QUES, KC_MUTE,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┬────┴───┬────┘        └───┬────┴───┬────┴───┬────┴───┬────┴────────┴────────┴────────┘
                                    _______, _______, KC_VOLD,                   KC_BRID, KC_BSPC, KC_DEL
                                // └────────┴────────┴────────┘                 └────────┴────────┴────────┘
  ),

  [_RAISE] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┐
     KC_F12,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                              KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,
  //├────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┤
     _______, _______, _______, _______, _______, _______,                            M(14),   M(15),   KC_PGUP, KC_PGDN, _______, _______,
  //├────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┤
     _______, M(10),   M(11),   M(12),   M(13),   M(9),                               M(3),    M(4),    M(5),    M(6),    _______, _______,
  //├────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┤
     _______, _______, _______, _______, _______, _______, _______,          M(17),   _______, M(19),   _______, _______, _______, _______,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┬────┴───┬────┘        └───┬────┴───┬────┴───┬────┴───┬────┴────────┴────────┴────────┘
                                    _______, _______, _______,                   M(16),   M(2),    M(18)
                                // └────────┴────────┴────────┘                 └────────┴────────┴────────┘
  )
};


const macro_t *action_get_macro(keyrecord_t *record, uint8_t id, uint8_t opt)
{
      switch(id) {
        // VIM macros
        case 0:
          // vim save document
          return MACRODOWN( TYPE(KC_ESC), DOWN(KC_LSFT), TYPE(KC_SCLN), UP(KC_LSFT), TYPE(KC_W), TYPE(KC_ENT), END );
          break;
        case 1:
          // vim quit document
          return MACRODOWN( TYPE(KC_ESC), DOWN(KC_LSFT), TYPE(KC_SCLN), UP(KC_LSFT), TYPE(KC_Q), TYPE(KC_ENT), END );
          break;

        // TMUX macros
          // tmux press ctrl-a
        case 2:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), END );
          break;
          // tmux full screen
        case 3:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_F), END );
          break;
          // tmux next window
        case 4:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_N), END );
          break;
          // tmux navigate pane down/up
        case 5:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_K), END );
          break;
          // tmux navigate pane left/right
        case 6:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_L), END );
          break;
          // tmux horizontal split
        case 7:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_PMNS), END );
          break;
          // tmux vertical split
        case 8:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_PEQL), END );
          break;

        // Openbox macros
          // toggle window on top
        case 9:
          return MACRODOWN( DOWN(KC_LALT), TYPE(KC_G), UP(KC_LALT), END );
          break;
          // move to desktop 1
        case 10:
          return MACRODOWN( DOWN(KC_LALT), TYPE(KC_A), UP(KC_LALT), END );
          break;
          // move to desktop 2
        case 11:
          return MACRODOWN( DOWN(KC_LALT), TYPE(KC_S), UP(KC_LALT), END );
          break;
          // move to desktop 3
        case 12:
          return MACRODOWN( DOWN(KC_LALT), TYPE(KC_D), UP(KC_LALT), END );
          break;
          // move to desktop 4
        case 13:
          return MACRODOWN( DOWN(KC_LALT), TYPE(KC_F), UP(KC_LALT), END );
          break;

        // Scroll tabs ctrl-tab
        case 14:
          return MACRODOWN( DOWN(KC_LCTL), DOWN(KC_LSFT), TYPE(KC_TAB), UP(KC_LSFT), UP(KC_LCTL), END );
          break;
        case 15:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_TAB), UP(KC_LCTL), END );
          break;

        // copy paste
        case 16:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_C), UP(KC_LCTL), END );
          break;
        case 17:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_V), UP(KC_LCTL), END );
          break;
        case 18:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), TYPE(KC_LBRC), END );
          break;

        // tmux 
        case 19:
          return MACRODOWN( DOWN(KC_LCTL), TYPE(KC_A), UP(KC_LCTL), DOWN(KC_RSFT), TYPE(KC_J), UP(KC_RSFT), END );

      }
    return MACRO_NONE;
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case QWERTY:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_QWERTY);
      }
      return false;
      break;
    case LOWER:
      if (record->event.pressed) {
        layer_on(_LOWER);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      } else {
        layer_off(_LOWER);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      }
      return false;
      break;
    case RAISE:
      if (record->event.pressed) {
        layer_on(_RAISE);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      } else {
        layer_off(_RAISE);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      }
      return false;
      break;
    case ADJUST:
      if (record->event.pressed) {
        layer_on(_ADJUST);
      } else {
        layer_off(_ADJUST);
      }
      return false;
      break;
  }
  return true;
}

//void matrix_init_user(void) {
//    set_unicode_input_mode(UC_LNX); // REPLACE UC_XXXX with the Unicode Input Mode for your OS. See table below.
//};

