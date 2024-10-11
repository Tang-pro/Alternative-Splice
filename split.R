library(argparser, quietly=TRUE)

# 创建参数解析器
p <- arg_parser("split expression/psi matrix by sample group")
p <- add_argument(p, "matrix", help="expression/psi matrix", type="character")
p <- add_argument(p, "sample_info", help="group \t sample", type="character")
p <- add_argument(p, "outdir", help="output dir", type="character")

# 解析命令行参数
argv <- parse_args(p)

# 读取表达式/psi矩阵文件
mats <- read.table(file = argv$matrix, header = TRUE, sep = "\t", check.names = FALSE)

# 读取样本信息文件
sample_info_tbl <- read.table(file = argv$sample_info, sep = "\t", header = FALSE)
colnames(sample_info_tbl) <- c("group", "sample")

# 将样本信息转换为列表，按组分割
sample_info_list <- split(sample_info_tbl$sample, sample_info_tbl$group)

# 按组分割矩阵并保存
for (g in names(sample_info_list)) {
  s <- sample_info_list[[g]]
  
  # 检查列名是否存在于mats中
  s <- s[s %in% colnames(mats)]
  if (length(s) == 0) {
    next
  }
  
  m <- mats[, s, drop = FALSE]
  dir.create(argv$outdir, showWarnings = FALSE, recursive = TRUE)
  write.table(m, file = paste0(argv$outdir, "/", g, ".txt"), quote = FALSE, sep = "\t")
}

