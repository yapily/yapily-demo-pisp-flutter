// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.sharedpreferences;

import android.content.Context;
import android.content.SharedPreferences.Editor;
import android.util.Base64;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/** SharedPreferencesPlugin */
@SuppressWarnings("unchecked")
public class SharedPreferencesPlugin implements MethodCallHandler {
  private static final String SHARED_PREFERENCES_NAME = "FlutterSharedPreferences";
  private static final String CHANNEL_NAME = "plugins.flutter.io/shared_preferences";

  // Fun fact: The following is a base64 encoding of the string "This is the prefix for a list."
  private static final String LIST_IDENTIFIER = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu";
  private static final String BIG_INTEGER_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy";

  private final android.content.SharedPreferences preferences;

  public static void registerWith(PluginRegistry.Registrar registrar) {
    MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    SharedPreferencesPlugin instance = new SharedPreferencesPlugin(registrar.context());
    channel.setMethodCallHandler(instance);
  }

  private SharedPreferencesPlugin(Context context) {
    preferences = context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
  }

  private List<String> decodeList(String encodedList) throws IOException {
    ObjectInputStream stream = null;
    try {
      stream = new ObjectInputStream(new ByteArrayInputStream(Base64.decode(encodedList, 0)));
      return (List<String>) stream.readObject();
    } catch (ClassNotFoundException e) {
      throw new IOException(e);
    } finally {
      if (stream != null) {
        stream.close();
      }
    }
  }

  private String encodeList(List<String> list) throws IOException {
    ObjectOutputStream stream = null;
    try {
      ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
      stream = new ObjectOutputStream(byteStream);
      stream.writeObject(list);
      stream.flush();
      return Base64.encodeToString(byteStream.toByteArray(), 0);
    } finally {
      if (stream != null) {
        stream.close();
      }
    }
  }

  // Filter preferences to only those set by the flutter app.
  private Map<String, Object> getAllPrefs() throws IOException {
    Map<String, ?> allPrefs = preferences.getAll();
    Map<String, Object> filteredPrefs = new HashMap<>();
    for (String key : allPrefs.keySet()) {
      if (key.startsWith("flutter.")) {
        Object value = allPrefs.get(key);
        if (value instanceof String) {
          String stringValue = (String) value;
          if (stringValue.startsWith(LIST_IDENTIFIER)) {
            value = decodeList(stringValue.substring(LIST_IDENTIFIER.length()));
          } else if (stringValue.startsWith(BIG_INTEGER_PREFIX)) {
            String encoded = stringValue.substring(BIG_INTEGER_PREFIX.length());
            value = new BigInteger(encoded, Character.MAX_RADIX);
          }
        } else if (value instanceof Set) {
          // This only happens for previous usage of setStringSet. The app expects a list.
          List<String> listValue = new ArrayList<>((Set) value);
          // Let's migrate the value too while we are at it.
          boolean success =
              preferences
                  .edit()
                  .remove(key)
                  .putString(key, LIST_IDENTIFIER + encodeList(listValue))
                  .commit();
          if (!success) {
            // If we are unable to migrate the existing preferences, it means we potentially lost them.
            // In this case, an error from getAllPrefs() is appropriate since it will alert the app during plugin initialization.
            throw new IOException("Could not migrate set to list");
          }
          value = listValue;
        }
        filteredPrefs.put(key, value);
      }
    }
    return filteredPrefs;
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    String key = call.argument("key");
    boolean status = false;
    try {
      switch (call.method) {
        case "setBool":
          status = preferences.edit().putBoolean(key, (boolean) call.argument("value")).commit();
          break;
        case "setDouble":
          float floatValue = ((Number) call.argument("value")).floatValue();
          status = preferences.edit().putFloat(key, floatValue).commit();
          break;
        case "setInt":
          Number number = call.argument("value");
          Editor editor = preferences.edit();
          if (number instanceof BigInteger) {
            BigInteger integerValue = (BigInteger) number;
            editor.putString(key, BIG_INTEGER_PREFIX + integerValue.toString(Character.MAX_RADIX));
          } else {
            editor.putLong(key, number.longValue());
          }
          status = editor.commit();
          break;
        case "setString":
          String value = (String) call.argument("value");
          if (value.startsWith(LIST_IDENTIFIER) || value.startsWith(BIG_INTEGER_PREFIX)) {
            result.error(
                "StorageError",
                "This string cannot be stored as it clashes with special identifier prefixes.",
                null);
            return;
          }
          status = preferences.edit().putString(key, value).commit();
          break;
        case "setStringList":
          List<String> list = call.argument("value");
          status = preferences.edit().putString(key, LIST_IDENTIFIER + encodeList(list)).commit();
          break;
        case "commit":
          // We've been committing the whole time.
          status = true;
          break;
        case "getAll":
          result.success(getAllPrefs());
          return;
        case "remove":
          status = preferences.edit().remove(key).commit();
          break;
        case "clear":
          Set<String> keySet = getAllPrefs().keySet();
          Editor clearEditor = preferences.edit();
          for (String keyToDelete : keySet) {
            clearEditor.remove(keyToDelete);
          }
          status = clearEditor.commit();
          break;
        default:
          result.notImplemented();
          break;
      }
      result.success(status);
    } catch (IOException e) {
      result.error("IOException encountered", call.method, e);
    }
  }
}
