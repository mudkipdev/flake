{ modelsDirectory, cacheDirectory }:

{
  model = "${cacheDirectory}/Qwen3-Coder-Next-Q3_K_M.gguf";
  settings = {
    "ctx-size" = 8192;
    "parallel" = 1;
    "n-gpu-layers" = 20;
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
