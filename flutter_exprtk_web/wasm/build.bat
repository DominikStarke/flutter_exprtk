emcc flutter_exprtk.cpp -s WASM=1 -o ../assets/flutter_exprtk.js -s "EXPORTED_RUNTIME_METHODS=['cwrap', 'allocateUTF8OnStack']" -s "EXPORTED_FUNCTIONS=['_free']" -O0

# for optimized builds:
# emcc flutter_exprtk.cpp -s WASM=1 -o flutter_exptrk.js  -s "EXPORTED_RUNTIME_METHODS=['cwrap', 'allocateUTF8OnStack', 'free']" -O3 -flto