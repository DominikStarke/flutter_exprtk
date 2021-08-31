emcc flutter_exprtk.cpp -s WASM=1 -o flutter_exptrk.html --shell-file shell_minimal.html  -s "EXPORTED_RUNTIME_METHODS=['cwrap', 'allocateUTF8OnStack']" -O0

# for optimized builds:
# emcc flutter_exprtk.cpp -s WASM=1 -o flutter_exptrk.html --shell-file shell_minimal.html  -s "EXPORTED_RUNTIME_METHODS=['cwrap', 'allocateUTF8OnStack']" -O3 -flto