@echo off
"C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\me88756\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\flutter_libserialport-0.5.0\\android\\libserialport" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=19" ^
  "-DANDROID_PLATFORM=android-19" ^
  "-DANDROID_ABI=x86" ^
  "-DCMAKE_ANDROID_ARCH_ABI=x86" ^
  "-DANDROID_NDK=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\me88756\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=C:\\Users\\me88756\\Projects\\Personal\\porsche-ebike-code-challenge\\build\\flutter_libserialport\\intermediates\\cxx\\Debug\\5b144a22\\obj\\x86" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=C:\\Users\\me88756\\Projects\\Personal\\porsche-ebike-code-challenge\\build\\flutter_libserialport\\intermediates\\cxx\\Debug\\5b144a22\\obj\\x86" ^
  "-DCMAKE_BUILD_TYPE=Debug" ^
  "-BC:\\Users\\me88756\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\flutter_libserialport-0.5.0\\android\\.cxx\\Debug\\5b144a22\\x86" ^
  -GNinja
