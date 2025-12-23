{ modelsDirectory, cacheDirectory }:

{
  model = "${cacheDirectory}/gemma-3-27b-it-Q4_K_M.gguf";
  settings = {
    "ctx-size" = 2048;
    "parallel" = 1;
    "n-gpu-layers" = 60;
    "cache-type-k" = "q4_0";
    "cache-type-v" = "q4_0";
    "threads" = 12;
    "threads-batch" = 12;
    "batch-size" = 512;
    "ubatch-size" = 128;
    "flash-attn" = true;
    "cont-batching" = true;
  };
}
