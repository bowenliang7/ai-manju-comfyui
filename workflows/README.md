# workflows/

把你在 ComfyUI 网页里做好的工作流，通过「Save (API format 也可另存一份)」导出成 `.json` 文件，放到这个目录下。

命名建议（方便以后管理多个分镜/角色/流程）：
- `01_角色设计.json`
- `02_分镜生成.json`
- `03_图生视频.json`
- `04_配音合成.json`

`setup.sh` 运行时会自动把这个目录下所有 `.json` 复制到 ComfyUI 的
`user/default/workflows/` 目录，打开网页后在左侧 Workflow 列表里就能直接看到、加载。

> 如果你是先跑一次空的 setup.sh（还没有workflow），以后做好了json文件再传上来，
> 重新执行一次 `bash setup.sh`（或者单独跑 `cp workflows/*.json ~/ComfyUI/user/default/workflows/`）即可同步。
