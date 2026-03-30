---
description: 精通项目文档编写的工作流，擅长根据当前文件夹内容自动生成标准化README.md文档，遵循项目的文档规范和格式约定。
---

$ARGUMENTS
<!-- OPENSPEC:START -->
**护栏规则**
- 为没有README.md的文件夹生成新的文档，已经存在的README.md根据实际情况更新内容
- 严格遵循项目现有的README格式和结构规范
- 优先分析技术栈和依赖文件来确定项目类型
- 生成的内容必须包含项目概述、技术栈、快速开始等标准章节
- 文档质量优先于速度，确保生成的内容准确有用
- 支持多种项目类型：Node.js、Go、Python、文档文件夹等
- 自动识别项目语言和框架，提供针对性的文档模板

**工作流步骤**
将这些步骤作为TODO跟踪并逐一完成。

## 阶段1：文件夹分析（Folder Analysis）
1. **检查现有README**: 检查文件夹是否已有README.md文件，确定是创建新文档还是更新现有文档
2. **扫描文件结构**: 递归分析文件夹中的所有文件和子目录
3. **识别项目类型**: 通过package.json、go.mod、requirements.txt等识别技术栈
4. **提取元信息**: 从配置文件、代码注释中提取项目描述和作者信息
5. **分析依赖关系**: 识别主要依赖库和框架版本
6. **确定文档范围**: 根据文件夹类型和现有文档内容决定需要哪些章节

## 阶段2：内容生成（Content Generation）
7. **生成项目概述**: 基于文件夹名称和内容推断项目目的
8. **构建技术栈章节**: 列出主要技术栈、依赖和版本信息
9. **创建项目结构**: 生成树状图展示文件夹组织结构
10. **编写快速开始**: 提供基本的安装和使用说明
11. **添加开发指南**: 包含代码规范、测试、构建等指导
12. **生成贡献指南**: 如果是开源项目，添加贡献说明

## 阶段3：格式化和验证（Formatting & Validation）
13. **应用项目格式**: 使用与主README一致的Markdown格式
14. **验证链接有效性**: 检查所有内部链接和引用是否正确
15. **语法检查**: 确保Markdown语法正确，无格式错误
16. **内容完整性检查**: 验证所有必要章节都已包含
17. **一致性验证**: 确保与项目整体风格保持一致

## 阶段4：文档优化（Documentation Enhancement）
18. **添加代码示例**: 为关键功能提供使用示例
19. **包含最佳实践**: 添加开发和使用的最佳实践建议
20. **生成API文档**: 如果是库项目，包含API使用说明
21. **添加故障排除**: 包含常见问题和解决方案
22. **国际化支持**: 为多语言项目添加语言切换说明

## 阶段5：质量保证（Quality Assurance）
23. **同行评审**: 邀请其他开发者review生成的内容
24. **用户测试**: 验证文档是否能指导新开发者快速上手
25. **更新维护**: 定期检查并更新过时的信息
26. **反馈收集**: 收集用户对文档的改进建议
27. **版本控制**: 跟踪文档版本，确保变更可追溯

**实施指南**

### 文件夹类型识别算法

```typescript
interface ProjectType {
  language: string;
  framework?: string;
  buildTool?: string;
  packageManager?: string;
}

function detectProjectType(files: string[]): ProjectType {
  // Node.js项目检测
  if (files.includes('package.json')) {
    const packageJson = JSON.parse(readFile('package.json'));

    if (packageJson.dependencies['react-native']) {
      return { language: 'TypeScript', framework: 'React Native', packageManager: 'yarn' };
    }
    if (packageJson.dependencies['react']) {
      return { language: 'TypeScript', framework: 'React', packageManager: 'npm' };
    }
    if (packageJson.dependencies['express']) {
      return { language: 'JavaScript', framework: 'Express.js' };
    }
  }

  // Go项目检测
  if (files.includes('go.mod')) {
    const goMod = readFile('go.mod');
    if (goMod.includes('gin')) {
      return { language: 'Go', framework: 'Gin' };
    }
    return { language: 'Go' };
  }

  // Python项目检测
  if (files.includes('requirements.txt') || files.includes('pyproject.toml')) {
    return { language: 'Python' };
  }

  // 文档文件夹检测
  if (files.some(f => f.endsWith('.md') && !f.includes('README'))) {
    return { language: 'Documentation' };
  }

  return { language: 'Unknown' };
}
```

### README结构生成器

```typescript
interface ReadmeSection {
  title: string;
  content: string;
  required: boolean;
}

class ReadmeGenerator {
  private sections: ReadmeSection[] = [];

  constructor(private projectType: ProjectType, private folderPath: string) {}

  generate(): string {
    this.addProjectOverview();
    this.addTechStack();
    this.addProjectStructure();
    this.addQuickStart();
    this.addDevelopmentGuide();

    return this.renderMarkdown();
  }

  private addProjectOverview() {
    const description = this.inferDescription();
    this.sections.push({
      title: '项目概述',
      content: description,
      required: true
    });
  }

  private addTechStack() {
    const techStack = this.extractTechStack();
    this.sections.push({
      title: '技术栈',
      content: techStack,
      required: true
    });
  }

  private inferDescription(): string {
    // 基于文件夹名称和内容推断描述
    const folderName = path.basename(this.folderPath);
    const description = `## ${folderName}\n\n${this.projectType.language}项目，${this.getPurpose()}`;
    return description;
  }

  private getPurpose(): string {
    switch (this.projectType.language) {
      case 'TypeScript':
        return this.projectType.framework === 'React Native' ? '移动端应用开发' : '前端开发';
      case 'Go':
        return '后端服务开发';
      case 'Python':
        return '数据处理或工具开发';
      default:
        return '功能模块开发';
    }
  }
}
```

### 项目结构树生成

```typescript
function generateProjectTree(rootPath: string, maxDepth: number = 3): string {
  const tree: string[] = [];
  const ignoredPatterns = ['node_modules', '.git', 'dist', 'build'];

  function buildTree(currentPath: string, prefix: string, depth: number) {
    if (depth > maxDepth) return;

    const items = fs.readdirSync(currentPath)
      .filter(item => !ignoredPatterns.some(pattern => item.includes(pattern)))
      .sort((a, b) => {
        // 目录优先排序
        const aIsDir = fs.statSync(path.join(currentPath, a)).isDirectory();
        const bIsDir = fs.statSync(path.join(currentPath, b)).isDirectory();
        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;
        return a.localeCompare(b);
      });

    items.forEach((item, index) => {
      const fullPath = path.join(currentPath, item);
      const isLast = index === items.length - 1;
      const isDir = fs.statSync(fullPath).isDirectory();

      const connector = isLast ? '└── ' : '├── ';
      tree.push(`${prefix}${connector}${item}${isDir ? '/' : ''}`);

      if (isDir) {
        const newPrefix = prefix + (isLast ? '    ' : '│   ');
        buildTree(fullPath, newPrefix, depth + 1);
      }
    });
  }

  const folderName = path.basename(rootPath);
  tree.push(folderName + '/');
  buildTree(rootPath, '', 0);

  return '```\n' + tree.join('\n') + '\n```';
}
```

### 技术栈提取器

```typescript
function extractTechStack(projectType: ProjectType, folderPath: string): string {
  const techStack: string[] = [];

  switch (projectType.language) {
    case 'TypeScript':
    case 'JavaScript':
      if (fs.existsSync(path.join(folderPath, 'package.json'))) {
        const packageJson = JSON.parse(fs.readFileSync(path.join(folderPath, 'package.json'), 'utf8'));

        techStack.push('### 核心依赖');
        Object.entries(packageJson.dependencies || {}).forEach(([dep, version]) => {
          if (isMajorDependency(dep)) {
            techStack.push(`- **${dep}**: ${version}`);
          }
        });

        if (packageJson.devDependencies) {
          techStack.push('\n### 开发依赖');
          Object.entries(packageJson.devDependencies).forEach(([dep, version]) => {
            if (isDevTool(dep)) {
              techStack.push(`- **${dep}**: ${version}`);
            }
          });
        }
      }
      break;

    case 'Go':
      if (fs.existsSync(path.join(folderPath, 'go.mod'))) {
        const goMod = fs.readFileSync(path.join(folderPath, 'go.mod'), 'utf8');
        techStack.push('### Go模块');
        goMod.split('\n').forEach(line => {
          if (line.startsWith('require ')) {
            techStack.push(`- ${line.replace('require ', '')}`);
          }
        });
      }
      break;
  }

  return techStack.join('\n');
}

function isMajorDependency(depName: string): boolean {
  const majorDeps = ['react', 'react-native', 'express', 'gin', 'gorm'];
  return majorDeps.some(dep => depName.includes(dep));
}

function isDevTool(depName: string): boolean {
  const devTools = ['typescript', 'webpack', 'babel', 'eslint', 'jest'];
  return devTools.some(tool => depName.includes(tool));
}
```

### 快速开始生成器

```typescript
function generateQuickStart(projectType: ProjectType): string {
  const steps: string[] = [];

  steps.push('### 前置要求');
  switch (projectType.language) {
    case 'TypeScript':
    case 'JavaScript':
      steps.push(`- Node.js >= 18.0.0`);
      steps.push(`- ${projectType.packageManager || 'npm'} >= 8.0.0`);
      break;
    case 'Go':
      steps.push('- Go >= 1.21');
      break;
    case 'Python':
      steps.push('- Python >= 3.8');
      steps.push('- pip >= 20.0');
      break;
  }

  steps.push('\n### 安装依赖');
  switch (projectType.language) {
    case 'TypeScript':
    case 'JavaScript':
      const pm = projectType.packageManager || 'npm';
      steps.push(`\`\`\`bash\n${pm} install\n\`\`\``);
      break;
    case 'Go':
      steps.push('```bash\ngo mod tidy\n```');
      break;
    case 'Python':
      steps.push('```bash\npip install -r requirements.txt\n```');
      break;
  }

  steps.push('\n### 运行项目');
  // 根据项目类型生成运行命令
  steps.push(getRunCommand(projectType));

  return steps.join('\n');
}

function getRunCommand(projectType: ProjectType): string {
  switch (projectType.framework) {
    case 'React Native':
      return '```bash\n# 启动开发服务器\nyarn start\n\n# 或指定平台\nyarn android\nyarn ios\n```';
    case 'React':
      return '```bash\nnpm start\n```';
    case 'Express.js':
      return '```bash\nnpm start\n```';
    case 'Gin':
      return '```bash\ngo run main.go\n```';
    default:
      return '```bash\n# 请查看package.json中的scripts或相关文档\n```';
  }
}
```

### 内容验证器

```typescript
interface ValidationResult {
  isValid: boolean;
  errors: string[];
  warnings: string[];
}

function validateReadme(content: string, projectType: ProjectType): ValidationResult {
  const result: ValidationResult = {
    isValid: true,
    errors: [],
    warnings: []
  };

  // 检查必要章节
  const requiredSections = ['项目概述', '技术栈', '快速开始'];
  requiredSections.forEach(section => {
    if (!content.includes(`## ${section}`)) {
      result.errors.push(`缺少必要章节：${section}`);
      result.isValid = false;
    }
  });

  // 检查Markdown语法
  const markdownIssues = validateMarkdownSyntax(content);
  result.errors.push(...markdownIssues.errors);
  result.warnings.push(...markdownIssues.warnings);

  // 检查链接有效性
  const linkIssues = validateLinks(content);
  result.warnings.push(...linkIssues);

  // 检查项目特定要求
  if (projectType.language === 'TypeScript') {
    if (!content.includes('TypeScript')) {
      result.warnings.push('TypeScript项目应提及TypeScript配置');
    }
  }

  return result;
}

function validateMarkdownSyntax(content: string): { errors: string[], warnings: string[] } {
  const errors: string[] = [];
  const warnings: string[] = [];

  // 检查未闭合的代码块
  const codeBlockCount = (content.match(/```/g) || []).length;
  if (codeBlockCount % 2 !== 0) {
    errors.push('存在未闭合的代码块');
  }

  // 检查格式一致性
  if (content.includes(' - ') && content.includes('  - ')) {
    warnings.push('列表缩进不一致，建议统一使用2个空格');
  }

  return { errors, warnings };
}

function validateLinks(content: string): string[] {
  const warnings: string[] = [];
  const linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;
  let match;

  while ((match = linkRegex.exec(content)) !== null) {
    const [fullMatch, text, url] = match;

    // 检查相对链接
    if (url.startsWith('./') || url.startsWith('../')) {
      // 这里可以添加更复杂的验证逻辑
      warnings.push(`相对链接可能需要验证：${url}`);
    }

    // 检查空链接文本
    if (!text.trim()) {
      warnings.push(`空链接文本：${fullMatch}`);
    }
  }

  return warnings;
}
```

### 模板系统

```typescript
interface ReadmeTemplate {
  [key: string]: {
    sections: string[];
    customContent?: { [section: string]: string };
  };
}

const TEMPLATES: ReadmeTemplate = {
  'react-native': {
    sections: ['项目概述', '技术栈', '项目结构', '快速开始', '开发指南', '测试', '构建部署'],
    customContent: {
      '开发指南': `
### 开发环境设置
- 安装Expo CLI：\`npm install -g @expo/cli\`
- 配置环境变量到.env文件

### 代码规范
- 使用TypeScript进行开发
- 遵循ESLint和Prettier配置
- 组件使用PascalCase命名
- Hooks使用camelCase命名

### 常用命令
\`\`\`bash
# 启动开发服务器
yarn start

# Android开发
yarn android

# iOS开发
yarn ios

# 类型检查
yarn type-check

# 代码检查
yarn lint
\`\`\`
      `,
      '测试': `
### 运行测试
\`\`\`bash
# 单元测试
yarn test

# 组件测试
yarn test:components

# E2E测试
yarn test:e2e
\`\`\`

### 测试覆盖率
目标覆盖率：
- 单元测试：80%
- 组件测试：70%
- E2E测试：50%
      `,
      '构建部署': `
### 开发构建
\`\`\`bash
yarn build:development
\`\`\`

### 生产构建
\`\`\`bash
# 使用Expo Application Services
npx eas build --platform all

# 或手动构建
yarn build:production
\`\`\`

### 发布应用
\`\`\`bash
# iOS TestFlight
npx eas submit --platform ios

# Android Google Play
npx eas submit --platform android
\`\`\`
      `
    }
  },

  'go-backend': {
    sections: ['项目概述', '技术栈', '项目结构', '快速开始', 'API文档', '数据库', '部署'],
    customContent: {
      'API文档': `
### API端点

#### 认证接口
- \`POST /api/v1/auth/login\` - 用户登录
- \`POST /api/v1/auth/register\` - 用户注册
- \`POST /api/v1/auth/refresh\` - 刷新令牌

#### 数据接口
- \`GET /api/v1/contacts\` - 获取联系人列表
- \`POST /api/v1/contacts/sync\` - 同步联系人数据
- \`GET /api/v1/reports/:id\` - 获取分析报告

### 请求示例
\`\`\`bash
curl -X POST http://localhost:8080/api/v1/auth/login \\
  -H "Content-Type: application/json" \\
  -d '{"email":"user@example.com","password":"password123"}'
\`\`\`
      `,
      '数据库': `
### 数据库配置

#### 本地开发
使用SQLite进行本地开发：
\`\`\`go
// config/database.go
dsn := "file:contacts.db?cache=shared&mode=rwc"
\`\`\`

#### 生产环境
使用PostgreSQL：
\`\`\`go
dsn := "host=localhost user=user password=password dbname=contacts port=5432 sslmode=disable"
\`\`\`

### 数据迁移
\`\`\`bash
# 生成迁移文件
migrate create -ext sql -dir migrations add_contacts_table

# 执行迁移
migrate -path migrations -database "postgres://..." up
\`\`\`
      `,
      '部署': `
### 本地部署
\`\`\`bash
# 编译
go build -o bin/server main.go

# 运行
./bin/server
\`\`\`

### Docker部署
\`\`\`dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o server main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from builder /app/server .
CMD ["./server"]
\`\`\`

### Serverless部署
\`\`\`bash
# 使用Serverless Devs
s deploy -t s-prod.yaml
\`\`\`
      `
    }
  },

  'documentation': {
    sections: ['概述', '目录结构', '主要文档', '贡献指南'],
    customContent: {
      '概述': '本文档目录包含项目相关的所有文档和技术规范。',
      '目录结构': '文档按功能模块组织，便于查找和维护。',
      '主要文档': `
### 核心文档
- \`project.md\` - 项目整体规范和技术栈说明
- \`AGENTS.md\` - AI助手开发指南
- \`domain-model.md\` - 领域模型设计
- \`server-plan.md\` - 后端开发计划

### 技术文档
- \`tech/\` - 技术实现和架构相关文档
- \`design/\` - UI设计和原型图
- \`domain-api.md\` - 领域API接口文档

### 规范文档
- \`TESTING_STANDARDS.md\` - 测试规范和标准
- \`TESTING_GUIDE.md\` - 测试实施指南
      `,
      '贡献指南': `
### 文档维护
1. 遵循现有的文档结构和格式
2. 更新 \`openspec/project.md\` 中的技术栈信息
3. 为新功能添加相应的规范文档
4. 定期review和更新过时的文档

### 写作规范
- 使用中文编写主要内容
- 保持技术准确性和时效性
- 提供实用的示例和代码片段
- 确保文档的可读性和易理解性
      `
    }
  }
};
```

### 集成工作流

```typescript
async function generateFolderReadme(folderPath: string): Promise<void> {
  // 1. 检查是否已有README
  const readmePath = path.join(folderPath, 'README.md');
  const existingReadme = fs.existsSync(readmePath);
  let existingContent = '';

  if (existingReadme) {
    existingContent = fs.readFileSync(readmePath, 'utf8');
    console.log('README.md已存在，将根据实际情况更新内容');
  } else {
    console.log('README.md不存在，将生成新的文档');
  }

  // 2. 分析文件夹内容
  const files = await scanFolder(folderPath);
  const projectType = detectProjectType(files);

  // 3. 生成或更新内容
  const generator = new ReadmeGenerator(projectType, folderPath);
  const newContent = generator.generate(existingContent);

  // 4. 验证内容
  const validation = validateReadme(newContent, projectType);
  if (!validation.isValid) {
    console.error('生成的内容不符合要求：', validation.errors);
    return;
  }

  if (validation.warnings.length > 0) {
    console.warn('生成的内容存在警告：', validation.warnings);
  }

  // 5. 写入文件
  fs.writeFileSync(readmePath, newContent, 'utf8');
  const action = existingReadme ? '更新' : '生成';
  console.log(`✅ 已${action}README.md: ${readmePath}`);

  // 6. 格式化（可选）
  await formatMarkdownFile(readmePath);
}

async function scanFolder(folderPath: string): Promise<string[]> {
  const files: string[] = [];

  function scan(currentPath: string) {
    const items = fs.readdirSync(currentPath);

    for (const item of items) {
      const fullPath = path.join(currentPath, item);
      const stat = fs.statSync(fullPath);

      if (stat.isDirectory()) {
        // 递归扫描，但避免node_modules等
        if (!['node_modules', '.git', 'dist', 'build'].includes(item)) {
          scan(fullPath);
        }
      } else {
        files.push(path.relative(folderPath, fullPath));
      }
    }
  }

  scan(folderPath);
  return files;
}

async function formatMarkdownFile(filePath: string): Promise<void> {
  // 这里可以集成Prettier或其他格式化工具
  try {
    const { execSync } = require('child_process');
    execSync(`npx prettier --write "${filePath}"`, { stdio: 'inherit' });
  } catch (error) {
    console.warn('格式化失败，使用默认格式');
  }
}
```

### 使用示例

```typescript
// 在.clinerules/workflows/中添加以下脚本
// generate-folder-readme.js

const path = require('path');
const fs = require('fs');

// 获取当前工作目录的子文件夹
const currentDir = process.cwd();
const subDirs = fs.readdirSync(currentDir)
  .filter(item => fs.statSync(path.join(currentDir, item)).isDirectory())
  .filter(dir => !dir.startsWith('.')); // 排除隐藏文件夹

console.log('发现以下子文件夹：', subDirs);

// 为每个子文件夹生成README
subDirs.forEach(async (dir) => {
  const folderPath = path.join(currentDir, dir);
  await generateFolderReadme(folderPath);
});
```

### 最佳实践

**内容质量保证**
- 生成的README应能让新开发者在5分钟内理解项目
- 避免过度技术细节，专注于实用信息
- 使用项目标准的Markdown格式和样式
- 定期review和更新生成的内容

**性能优化**
- 缓存分析结果，避免重复扫描
- 支持增量更新，只更新变更的部分
- 并行处理多个文件夹的生成
- 限制扫描深度，避免过度分析

**扩展性设计**
- 支持自定义模板和规则
- 允许插件化扩展功能
- 提供配置选项适应不同项目需求
- 支持多种输出格式（Markdown、HTML等）

**错误处理**
- 优雅处理文件权限问题
- 提供有意义的错误信息
- 支持恢复机制，避免数据丢失
- 记录生成日志便于调试

### 质量检查清单

- [ ] README为没有readme的文件夹生成新的文档，已经存在的README.md根据实际情况更新内容
- [ ] 包含所有必要章节（概述、技术栈、快速开始）
- [ ] Markdown语法正确，无格式错误
- [ ] 链接和引用都有效
- [ ] 内容与项目整体风格一致
- [ ] 技术信息准确，版本号正确
- [ ] 代码示例可运行，命令正确
- [ ] 文档结构清晰，易于阅读
- [ ] 遵循项目的命名和格式规范
- [ ] 通过人工review验证内容质量

**参考**
- 项目README格式参考根目录的`README.md`
- 技术栈信息参考`openspec/project.md`
- 代码规范参考`openspec/project.md`的代码风格章节
- OpenSpec规范参考`openspec/project.md`和`openspec/AGENTS.md`
<!-- OPENSPEC:END -->
