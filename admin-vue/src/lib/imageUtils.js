/**
 * Image compression utilities
 */

/**
 * 压缩图片到指定尺寸
 * @param {File} file - 原始文件
 * @param {number} maxWidth - 最大宽度
 * @param {number} maxHeight - 最大高度
 * @param {number} quality - 压缩质量 (0-1)
 * @returns {Promise<Blob>} 压缩后的图片 Blob
 */
export async function compressImage(file, maxWidth = 800, maxHeight = 800, quality = 0.8) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    const reader = new FileReader();

    reader.onload = (e) => {
      img.src = e.target.result;
    };

    reader.onerror = () => {
      reject(new Error("图片读取失败"));
    };

    img.onload = () => {
      // Calculate dimensions
      let width = img.width;
      let height = img.height;

      if (width > maxWidth || height > maxHeight) {
        const ratio = Math.min(maxWidth / width, maxHeight / height);
        width = Math.round(width * ratio);
        height = Math.round(height * ratio);
      }

      // Create canvas and compress
      const canvas = document.createElement("canvas");
      canvas.width = width;
      canvas.height = height;
      const ctx = canvas.getContext("2d");
      ctx.drawImage(img, 0, 0, width, height);

      canvas.toBlob(
        (blob) => {
          if (!blob) {
            reject(new Error("图片压缩失败"));
            return;
          }
          resolve(blob);
        },
        file.type || "image/jpeg",
        quality
      );
    };

    img.onerror = () => {
      reject(new Error("图片加载失败"));
    };

    reader.readAsDataURL(file);
  });
}

/**
 * 获取图片的显示尺寸（用于 UI）
 * @param {number} width - 原始宽度
 * @param {number} height - 原始高度
 * @returns {string} 格式化的尺寸字符串
 */
export function formatImageSize(width, height) {
  if (!width || !height) return "";
  const format = (num) => {
    if (num >= 1024 * 1024) return `${(num / (1024 * 1024)).toFixed(1)}MP`;
    if (num >= 1024) return `${(num / 1024).toFixed(1)}K`;
    return `${num}px`;
  };
  return `${format(width)} × ${format(height)}`;
}

/**
 * 计算压缩前后的大小差异
 * @param {number} originalSize - 原始大小（字节）
 * @param {number} compressedSize - 压缩后大小（字节）
 * @returns {string} 格式化的差异字符串
 */
export function formatCompressionDiff(originalSize, compressedSize) {
  const ratio = ((originalSize - compressedSize) / originalSize) * 100;
  if (ratio > 0) {
    return `压缩节省 ${ratio.toFixed(0)}%`;
  } else if (ratio < 0) {
    return `压缩后增加 ${Math.abs(ratio).toFixed(0)}%`;
  }
  return "大小相同";
}