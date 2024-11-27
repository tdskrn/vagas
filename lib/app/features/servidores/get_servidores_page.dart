import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vagas/app/core/config/enumSecretaria.dart';
import 'package:vagas/app/core/config/enumVinculos.dart';
import 'package:vagas/app/core/config/enumSituacaoAtual.dart'; // Importando o enum SituacaoAtual
import 'package:vagas/app/core/utils.dart';
import 'package:vagas/app/features/servidores/components/row_component.dart';
import 'package:vagas/app/features/servidores/servidor_detail_widget.dart';

class GetServidoresPage extends StatefulWidget {
  const GetServidoresPage({super.key});

  @override
  State<GetServidoresPage> createState() => _GetServidoresPageState();
}

class _GetServidoresPageState extends State<GetServidoresPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  Secretaria? _selectedSecretaria;
  Vinculo? _selectedVinculo;
  SituacaoAtual? _selectedSituacao;

  void _performSearch() {
    setState(() {
      _searchValue = _searchController.text.trim();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchValue = '';
      _selectedSecretaria = null;
      _selectedVinculo = null;
      _selectedSituacao = null;
    });
  }

  Query<Map<String, dynamic>> _buildQuery() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('teste').orderBy('nome_servidor');

    if (_searchValue.isNotEmpty) {
      query = query.startAt([_searchValue]).endAt([_searchValue + '\uf8ff']);
    }

    if (_selectedSecretaria != null) {
      query = query.where('secretaria', isEqualTo: _selectedSecretaria?.name);
    }

    if (_selectedVinculo != null) {
      query = query.where('vinculo', isEqualTo: _selectedVinculo?.name);
    }

    if (_selectedSituacao != null) {
      query = query.where('situacao_atual',
          isEqualTo: _selectedSituacao?.getName());
    }

    return query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Pesquise por nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Pesquisar'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Secretaria>(
                    value: _selectedSecretaria,
                    onChanged: (value) =>
                        setState(() => _selectedSecretaria = value),
                    hint: const Text('Selecione a Secretaria'),
                    items: Secretaria.values.map((secretaria) {
                      return DropdownMenuItem(
                        value: secretaria,
                        child: Text(secretaria.name),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Vinculo>(
                    value: _selectedVinculo,
                    onChanged: (value) =>
                        setState(() => _selectedVinculo = value),
                    hint: const Text('Selecione o Vínculo'),
                    items: Vinculo.values.map((vinculo) {
                      return DropdownMenuItem(
                        value: vinculo,
                        child: Text(vinculo.name),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<SituacaoAtual>(
                    value: _selectedSituacao,
                    onChanged: (value) =>
                        setState(() => _selectedSituacao = value),
                    hint: const Text('Selecione a Situação'),
                    items: SituacaoAtual.values.map((situacao) {
                      return DropdownMenuItem(
                        value: situacao,
                        child: Text(situacao.getName()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: _resetFilters,
              child: const Text('Resetar Filtros'),
            ),
          ),
          Row(
            children: [
              RowComponent('NOME SERVIDOR', 3, Colors.blue,
                  textColor: Colors.white),
              RowComponent('SERVIDOR 2025', 3, Colors.blue,
                  textColor: Colors.white),
              RowComponent('CARGO', 3, Colors.blue, textColor: Colors.white),
              RowComponent('SECRETARIA', 3, Colors.blue,
                  textColor: Colors.white),
              RowComponent('VINCULO', 3, Colors.blue, textColor: Colors.white),
              // RowComponent('TOTAL BRUTO', 2, Colors.blue,
              //     textColor: Colors.white),
              RowComponent('AÇÕES', 1, Colors.blue, textColor: Colors.white),
            ],
          ),
          Expanded(
            child: FirestoreListView(
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text('Erro: $error'),
              ),
              pageSize: 10,
              query: _buildQuery(),
              itemBuilder: (context, snapshot) {
                final data = snapshot.data();
                return Row(
                  children: [
                    RowComponent(
                        data['nome_servidor'] ?? 'Sem Nome', 3, Colors.white),
                    RowComponent(
                        data['servidor_2025'] ?? 'Sem Nome', 3, Colors.white),
                    RowComponent(data['cargo'] ?? 'Sem Nome', 3, Colors.white),
                    RowComponent(
                        data['secretaria'] ?? 'Sem Nome', 3, Colors.white),
                    RowComponent(
                        data['vinculo'] ?? 'Sem Nome', 3, Colors.white),
                    // RowComponent(
                    //   data['total_bruto'] != null
                    //       ? "R\$ ${data['total_bruto'].toStringAsFixed(2)}"
                    //       : "N/A",
                    //   2,
                    //   Colors.white,
                    // ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServidorDetail(
                                data: data,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
