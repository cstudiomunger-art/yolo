/* ChinaGo Admin — Quill rich text helpers */

(function () {
  const App = window.ChinaGoAdmin;

  const DEFAULT_TOOLBAR = [
    ["bold", "italic", "underline"],
    [{ header: [2, 3, false] }],
    [{ list: "ordered" }, { list: "bullet" }],
    ["link"],
    ["clean"],
  ];

  App.isLikelyHtml = function isLikelyHtml(text) {
    if (!text || typeof text !== "string") return false;
    return /<[a-z][\s\S]*?>/i.test(text);
  };

  App.plainTextToHtml = function plainTextToHtml(text) {
    if (!text) return "";
    if (App.isLikelyHtml(text)) return text;
    return text
      .split(/\n\n+/)
      .map((p) => `<p>${App.escapeHtml(p).replace(/\n/g, "<br>")}</p>`)
      .join("");
  };

  App.sanitizeHtml = function sanitizeHtml(html) {
    if (!html || typeof html !== "string") return "";
    let out = html.trim();
    if (!out || out === "<p><br></p>" || out === "<p></p>") return "";

    out = out.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, "");
    out = out.replace(/\s+on\w+="[^"]*"/gi, "");
    out = out.replace(/\s+on\w+='[^']*'/gi, "");
    out = out.replace(/javascript:/gi, "");
    return out;
  };

  App.buildQuillToolbar = function buildQuillToolbar(compact, withImage) {
    if (compact) {
      const row = [["bold", "italic"], [{ list: "ordered" }, { list: "bullet" }]];
      row.push(withImage ? ["image", "link"] : ["link"]);
      row.push(["clean"]);
      return row;
    }
    const toolbar = [
      ["bold", "italic", "underline"],
      [{ header: [2, 3, false] }],
      [{ list: "ordered" }, { list: "bullet" }],
    ];
    toolbar.push(withImage ? ["link", "image"] : ["link"]);
    toolbar.push(["clean"]);
    return toolbar;
  };

  App.getQuillToolbar = function getQuillToolbar(compact, opts) {
    return App.buildQuillToolbar(compact, !!(opts && opts.image));
  };

  App.richTextFieldRoot = function richTextFieldRoot(hostEl) {
    return hostEl.closest(".sub-area-inline-form, form, .edit-form, .modal, .editor-page");
  };

  App.isQuillHostLive = function isQuillHostLive(hostEl) {
    const quill = hostEl?._quill;
    return !!(quill?.root?.isConnected && hostEl?.isConnected);
  };

  App.isHostVisibleForQuill = function isHostVisibleForQuill(hostEl) {
    if (!hostEl?.isConnected) return false;
    return hostEl.offsetParent !== null && hostEl.getClientRects().length > 0;
  };

  App.destroyQuillHost = function destroyQuillHost(hostEl) {
    if (!hostEl) return;
    if (hostEl._quill) {
      try {
        App.syncQuillHost(hostEl);
      } catch (_) {
        /* ignore */
      }
      try {
        hostEl._quill.disable();
      } catch (_) {
        /* ignore detached selection errors */
      }
      delete hostEl._quill;
    }
    const name = hostEl.dataset.fieldName;
    const hidden = name ? hostEl.querySelector(`input[type="hidden"][name="${name}"]`) : null;
    const html =
      hidden?.value ||
      hostEl.querySelector(".ql-editor")?.innerHTML ||
      hostEl.querySelector(".rich-text-editor")?.innerHTML ||
      "";
    hostEl.querySelectorAll(".ql-toolbar, .ql-container").forEach((node) => node.remove());
    let editor = hostEl.querySelector(".rich-text-editor");
    if (!editor) {
      editor = document.createElement("div");
      editor.className = "rich-text-editor";
      hostEl.insertBefore(editor, hostEl.firstChild);
    }
    editor.innerHTML = html;
    delete hostEl.dataset.quillMounted;
    delete hostEl.dataset.quillPending;
  };

  App.destroyQuillInRoot = function destroyQuillInRoot(root) {
    const scope = root || document;
    scope.querySelectorAll(".rich-text-host").forEach((host) => App.destroyQuillHost(host));
  };

  App.resolveRichTextEntityId = function resolveRichTextEntityId(hostEl) {
    const root = App.richTextFieldRoot(hostEl);
    if (!root) return null;
    const entityField = hostEl.dataset.uploadEntityField || "id";
    const el = root.querySelector(`[name="${entityField}"]`);
    const existing = el?.value?.trim();
    if (existing) return existing;
    const slugSource = hostEl.dataset.uploadSlugSource;
    if (!slugSource) return null;
    const srcEl = root.querySelector(`[name="${slugSource}"]`);
    const src = srcEl?.value?.trim();
    if (!src) return null;
    let prefix = hostEl.dataset.uploadSlugPrefix || "";
    const prefixField = hostEl.dataset.uploadSlugPrefixField;
    if (prefixField) {
      const pf = root.querySelector(`[name="${prefixField}"]`);
      prefix = pf?.value?.trim() || prefix;
    }
    return App.slugify(src, prefix);
  };

  App.quillPickAndUploadImage = function quillPickAndUploadImage(hostEl) {
    const quill = hostEl._quill;
    if (!quill) return;
    const folder = hostEl.dataset.uploadFolder;
    if (!folder) return;

    const input = document.createElement("input");
    input.type = "file";
    input.accept = "image/jpeg,image/png,image/webp";
    input.addEventListener("change", async () => {
      const file = input.files?.[0];
      if (!file) return;
      const entityId = App.resolveRichTextEntityId(hostEl);
      if (!entityId) {
        App.showToast("请先填写名称后再插入图片", "error");
        return;
      }
      try {
        App.showToast("图片上传中…");
        const url = await App.uploadGalleryImage(file, folder, entityId, `rte_${Date.now()}`);
        let index = 0;
        if (App.isQuillHostLive(hostEl)) {
          try {
            const range = quill.getSelection();
            index = range ? range.index : Math.max(0, quill.getLength() - 1);
          } catch (_) {
            index = Math.max(0, quill.getLength() - 1);
          }
        }
        quill.insertEmbed(index, "image", url, "user");
        try {
          if (App.isQuillHostLive(hostEl)) quill.setSelection(index + 1, 0, "silent");
        } catch (_) {
          /* selection not in document — safe to ignore */
        }
        App.showToast("图片已插入");
      } catch (ex) {
        App.showToast(ex.message || "上传失败", "error");
      }
    });
    input.click();
  };

  App.createQuillEditor = function createQuillEditor(hostEl, initialHtml, options = {}) {
    if (!window.Quill) {
      throw new Error("富文本编辑器未加载，请刷新页面");
    }
    const editorEl = hostEl.querySelector(".rich-text-editor");
    if (!editorEl) throw new Error("缺少 .rich-text-editor 容器");

    const withImage = !!options.uploadFolder;
    const toolbarContainer = App.buildQuillToolbar(options.compact, withImage);
    const modules = {
      toolbar: withImage
        ? {
            container: toolbarContainer,
            handlers: {
              image: () => App.quillPickAndUploadImage(hostEl),
            },
          }
        : toolbarContainer,
    };

    const quill = new Quill(editorEl, {
      theme: "snow",
      modules,
      placeholder: options.placeholder || "输入内容…",
    });

    // Initial HTML is already in .rich-text-editor; avoid dangerouslyPasteHTML (breaks selection).

    hostEl._quill = quill;
    hostEl.dataset.quillMounted = "1";
    return quill;
  };

  App.getQuillHtml = function getQuillHtml(quillOrHost) {
    const hostEl = quillOrHost?.root ? quillOrHost.root.closest(".rich-text-host") : quillOrHost;
    const quill = quillOrHost?.root ? quillOrHost : quillOrHost?._quill;
    if (quill && App.isQuillHostLive(hostEl || quill.root)) {
      try {
        return App.sanitizeHtml(quill.root.innerHTML);
      } catch (_) {
        /* fall through */
      }
    }
    if (hostEl) {
      const hidden = hostEl.querySelector(`input[type="hidden"][name="${hostEl.dataset.fieldName}"]`);
      if (hidden?.value) return App.sanitizeHtml(hidden.value);
      const editor = hostEl.querySelector(".ql-editor") || hostEl.querySelector(".rich-text-editor");
      if (editor) return App.sanitizeHtml(editor.innerHTML);
    }
    return "";
  };

  App.renderRichTextHost = function renderRichTextHost(name, value, options = {}) {
    const compact = options.compact ? " rich-text-host--compact" : "";
    const initial = App.plainTextToHtml(value || "");
    let uploadAttrs = "";
    if (options.uploadFolder) {
      uploadAttrs += ` data-upload-folder="${App.escapeHtml(options.uploadFolder)}"`;
      uploadAttrs += ` data-upload-entity-field="${App.escapeHtml(options.uploadEntityField || "id")}"`;
      if (options.uploadSlugSource) {
        uploadAttrs += ` data-upload-slug-source="${App.escapeHtml(options.uploadSlugSource)}"`;
      }
      if (options.uploadSlugPrefix) {
        uploadAttrs += ` data-upload-slug-prefix="${App.escapeHtml(options.uploadSlugPrefix)}"`;
      }
      if (options.uploadSlugPrefixField) {
        uploadAttrs += ` data-upload-slug-prefix-field="${App.escapeHtml(options.uploadSlugPrefixField)}"`;
      }
    }
    return `<div class="rich-text-host${compact}" data-field-name="${App.escapeHtml(name)}"${uploadAttrs}>
      <div class="rich-text-editor">${initial ? initial : ""}</div>
    </div>`;
  };

  App.syncQuillHost = function syncQuillHost(host) {
    if (!host?.dataset?.fieldName) return;
    const name = host.dataset.fieldName;
    const html = App.getQuillHtml(host);
    let hidden = host.querySelector(`input[type="hidden"][name="${name}"]`);
    if (!hidden) {
      hidden = document.createElement("input");
      hidden.type = "hidden";
      hidden.name = name;
      host.appendChild(hidden);
    }
    hidden.value = html;
  };

  App.initRichTextHost = function initRichTextHost(hostEl, options = {}) {
    if (!hostEl || hostEl.dataset.quillMounted === "1") return hostEl._quill;
    if (!App.isHostVisibleForQuill(hostEl)) {
      hostEl.dataset.quillPending = "1";
      return null;
    }
    delete hostEl.dataset.quillPending;
    const initial = hostEl.querySelector(".rich-text-editor")?.innerHTML || "";
    const uploadFolder = hostEl.dataset.uploadFolder || options.uploadFolder;
    return App.createQuillEditor(hostEl, initial, {
      ...options,
      compact: hostEl.classList.contains("rich-text-host--compact"),
      uploadFolder,
    });
  };

  App.initRichTextHosts = function initRichTextHosts(root, options = {}) {
    const scope = root || document;
    scope.querySelectorAll(".rich-text-host").forEach((host) => {
      if (host.dataset.quillMounted === "1") return;
      App.initRichTextHost(host, options);
    });
  };

  App.ensurePendingQuillHosts = function ensurePendingQuillHosts(root) {
    const scope = root || document;
    scope.querySelectorAll('.rich-text-host[data-quill-pending="1"]').forEach((host) => {
      if (App.isHostVisibleForQuill(host)) App.initRichTextHost(host);
    });
  };

  App.bindDeferredQuillHosts = function bindDeferredQuillHosts(root) {
    const scope = root || document;
    requestAnimationFrame(() => App.ensurePendingQuillHosts(scope));
    scope.querySelectorAll("details.sub-area-block").forEach((details) => {
      if (details.dataset.quillToggleBound === "1") return;
      details.dataset.quillToggleBound = "1";
      details.addEventListener("toggle", () => {
        const hosts = details.querySelectorAll(".rich-text-host");
        if (details.open) {
          hosts.forEach((host) => App.initRichTextHost(host));
        } else {
          hosts.forEach((host) => {
            App.syncQuillHost(host);
            App.destroyQuillHost(host);
          });
        }
      });
    });
  };

  App.syncAllQuillFields = function syncAllQuillFields(root) {
    const scope = root || document;
    scope.querySelectorAll(".rich-text-host[data-field-name]").forEach((host) => {
      const name = host.dataset.fieldName;
      if (!name) return;
      const html = App.getQuillHtml(host);
      let hidden = host.querySelector(`input[type="hidden"][name="${name}"]`);
      if (!hidden) {
        hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = name;
        host.appendChild(hidden);
      }
      hidden.value = html;
    });
  };

  App.readRichTextValue = function readRichTextValue(form, fieldKey) {
    const host = form.querySelector(`.rich-text-host[data-field-name="${fieldKey}"]`);
    if (host?._quill) return App.getQuillHtml(host);
    const hidden = form.querySelector(`input[type="hidden"][name="${fieldKey}"]`);
    if (hidden) return App.sanitizeHtml(hidden.value);
    return "";
  };

  App.readContentBlockBody = function readContentBlockBody(row) {
    const host = row.querySelector(".content-block-body-host");
    if (host?._quill) return App.getQuillHtml(host);
    const ta = row.querySelector('[data-field="body"]');
    return ta?.value?.trim() || "";
  };

  /** Legacy sub-area content_blocks → single HTML for richtext editor. */
  App.contentBlocksToHtml = function contentBlocksToHtml(blocks) {
    if (!Array.isArray(blocks) || !blocks.length) return "";
    let html = "";
    blocks.forEach((item) => {
      const blockType = App.inferContentBlockType ? App.inferContentBlockType(item) : item.type || "paragraph";
      const title = (item.title || "").trim();
      const body = (item.body || "").trim();
      const imagePath = (item.imagePath || item.image_path || "").trim();
      if (blockType === "heading") {
        if (title) html += `<h2>${App.escapeHtml(title)}</h2>`;
      } else if (blockType === "image") {
        const src = imagePath || body;
        if (src) {
          html += `<p><img src="${App.escapeHtml(src)}" alt=""></p>`;
          if (title) html += `<p><em>${App.escapeHtml(title)}</em></p>`;
        }
      } else if (body) {
        html += App.isLikelyHtml(body) ? body : App.plainTextToHtml(body);
      } else if (title) {
        html += `<p>${App.escapeHtml(title)}</p>`;
      }
    });
    return html;
  };
})();
