{ modelsDirectory, cacheDirectory }:

{
  model = "${cacheDirectory}/GLM-4.7-Flash-Q4_K_M.gguf";
  settings = {
    "ctx-size" = 8192;
    "parallel" = 1;
    "n-gpu-layers" = 28;
    "n-cpu-moe" = 8;
    "cache-type-k" = "q8_0";
    "cache-type-v" = "q8_0";
    "threads" = 12;
    "threads-batch" = 12;
    "batch-size" = 512;
    "ubatch-size" = 128;
    "flash-attn" = true;
    "cont-batching" = true;
  };
}
