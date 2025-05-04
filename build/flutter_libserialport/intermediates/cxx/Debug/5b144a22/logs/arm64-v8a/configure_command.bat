@echo off
"C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\me88756\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\flutter_libserialport-0.5.0\\android\\libserialport" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=19" ^
  "-DANDROID_PLATFORM=android-19" ^
  "-DANDROID_ABI=arm64-v8a" ^
  "-DCMAKE_ANDROID_ARCH_ABI=arm64-v8a" ^
  "-DANDROID_NDK=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=C:\\Users\\me88756\\Projects\\Personal\\porsche-ebike-code-challenge\\build\\flutter_libserialport\\intermediates\\cxx\\Debug\\5b144a22\\obj\\arm64-v8a" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=C:\\Users\\me88756\\Projects\\Personal\\porsche-ebike-code-challenge\\build\\flutter_libserialport\\intermediates\\cxx\\Debug\\5b144a22\\obj\\arm64-v8a" ^
  "-DCMAKE_BUILD_TYPE=Debug" ^
  "-BC:\\Users\\me88756\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\flutter_libserialport-0.5.0\\android\\.cxx\\Debug\\5b144a22\\arm64-v8a" ^
  -GNinja
